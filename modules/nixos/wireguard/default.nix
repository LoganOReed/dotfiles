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
    sops.secrets."razor/wireguard/us-nyc-wg-404/private_key" = {};
    sops.templates."/etc/mullvad-vpn.key".content = ''${config.sops.placeholder."razor/wireguard/us-nyc-wg-404/private_key"}'';
    sops.templates."/etc/mullvad-vpn.key".owner = "root";

    networking.wg-quick.interfaces = let
      server_ip = "198.44.136.194";
    in {
      wg0 = {
        # IP address of this machine in the *tunnel network*
        address = [
          "10.64.195.6/32"
          "fc00:bbbb:bbbb:bb01::1:c305/128"
        ];

        # To match firewall allowedUDPPorts (without this wg
        # uses random port numbers).
        listenPort = 51820;

        # Path to the private key file.
        privateKeyFile = "${config.sops.templates."/etc/mullvad-vpn.key".path}";

        peers = [
          {
            publicKey = "pCZ9NnIgAEwrDy4H/eGz8NvNcbAg7UGFTGYruyCfVwU=";
            allowedIPs = ["0.0.0.0/0" "::0/0"];
            endpoint = "${server_ip}:51820";
            persistentKeepalive = 25;
          }
        ];

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
          # ${pkgs.iptables}/bin/iptables -A INPUT -i wg0 -p udp \
          #     --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
          # ${pkgs.iptables}/bin/iptables -A INPUT -i wg0 -p tcp \
          #     --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
          # ${pkgs.iptables}/bin/iptables -A OUTPUT -o wg0 -p udp \
          #     --sport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
          # ${pkgs.iptables}/bin/iptables -A OUTPUT -o wg0 -p tcp \
          #     --sport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
        '';

        postDown = ''
          ${pkgs.iptables}/bin/iptables -I OUTPUT -o lo -p tcp \
              --dport 6600 -m state --state NEW,ESTABLISHED -j ACCEPT

          ${pkgs.iptables}/bin/iptables -I OUTPUT -d 127.0.0.0/16 \
              -j ACCEPT
        '';

        # postSetup = ''
        # # Accept kdeconnect connections
        # ${pkgs.iptables}/bin/iptables -A INPUT -i wg0 -p udp \
        #     --dport 1714:1764 -m state --state NEW,ESTABLISHED -j ACCEPT
        # ${pkgs.iptables}/bin/iptables -A INPUT -i wg0 -p tcp \
        #     --dport 1714:1764 -m state --state NEW,ESTABLISHED -j ACCEPT
        # ${pkgs.iptables}/bin/iptables -A OUTPUT -o wg0 -p udp \
        #     --sport 1714:1764 -m state --state NEW,ESTABLISHED -j ACCEPT
        # ${pkgs.iptables}/bin/iptables -A OUTPUT -o wg0 -p tcp \
        #     --sport 1714:1764 -m state --state NEW,ESTABLISHED -j ACCEPT
        #
        #   # Allow deluge web gui
        #   ${pkgs.iptables}/bin/iptables -I OUTPUT -o lo -p tcp \
        #       --dport 8112 -m state --state NEW,ESTABLISHED -j ACCEPT
        #
        # '';
      };
    };
  };
}
