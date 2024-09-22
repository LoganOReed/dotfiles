# This is where all of the setup is from
# https://alberand.com/nixos-wireguard-vpn.html
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.wireguard;
in {
  options.modules.wireguard = {enable = mkEnableOption "wireguard";};
  config = mkIf cfg.enable {
    sops.secrets."${config.networking.hostName}/wireguard/private_key" = {};
    sops.templates."/etc/mullvad-vpn.key".content = ''${config.sops.placeholder."${config.networking.hostName}/wireguard/private_key"}'';
    sops.templates."/etc/mullvad-vpn.key".owner = "root";

    sops.templates."/etc/wg0.conf".content = ''
[Interface]
PrivateKey = ${config.sops.placeholder."${config.networking.hostName}/wireguard/private_key"}
Address = ${config.sops.placeholder."${config.networking.hostName}/wireguard/address"}
DNS = 10.64.0.1


[Peer]
PublicKey = ${config.sops.placeholder."${config.networking.hostName}/wireguard/public_key"}
AllowedIPs = 0.0.0.0/0,::0/0
Endpoint = ${config.sops.placeholder."${config.networking.hostName}/wireguard/endpoint"}
PersistentKeepAlive = 25
  '';
    sops.templates."/etc/wg0.conf".owner = "root";

    networking.wg-quick.interfaces = {
      wg0 = {
        configFile = ''${config.sops.templates."/etc/wg0.conf".path}'';
        privateKeyFile = "${config.sops.templates."/etc/mullvad-vpn.key".path}";

        postUp = ''
          # Mark packets on the wg0 interface
          wg set wg0 fwmark 51820

          # Forbid anything else which doesn't go through wireguard VPN on
          # ipV4 and ipV6
          ${pkgs.iptables}/bin/iptables -A OUTPUT \
            ! -d 192.168.0.0/16 \
            ! -o wg0 \
            -m mark ! --mark $(wg show wg0 fwmark) \
            -m addrtype ! --dst-type LOCAL \
            -j REJECT
          ${pkgs.iptables}/bin/ip6tables -A OUTPUT \
            ! -o wg0 \
            -m mark ! --mark $(wg show wg0 fwmark) \
            -m addrtype ! --dst-type LOCAL \
            -j REJECT

          # Accept kdeconnect connections
          ${pkgs.iptables}/bin/iptables -A INPUT -i wg0 -p udp \
              --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A INPUT -i wg0 -p tcp \
              --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A OUTPUT -o wg0 -p udp \
              --sport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A OUTPUT -o wg0 -p tcp \
              --sport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
        '';

        postDown = ''
          ${pkgs.iptables}/bin/iptables -I OUTPUT -o lo -p tcp \
              --dport 6600 -m state --state NEW,ESTABLISHED -j ACCEPT

          ${pkgs.iptables}/bin/iptables -I OUTPUT -d 127.0.0.0/16 \
              -j ACCEPT
        '';

      };
    };
  };
}
