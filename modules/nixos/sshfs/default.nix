# This is where all of the setup is from
# https://alberand.com/nixos-wireguard-vpn.html
{
  pkgs,
  lib,
  config,
  sops,
  ...
}:
with lib; let
  cfg = config.modules.sshfs;
in {
  options.modules.sshfs = {enable = mkEnableOption "sshfs";};
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      sshfs sshfs-fuse
    ];


  fileSystems =
    let
      # Use the user's gpg-agent session to query
      # for the password of the SSH key when auto-mounting.
      sshAsUser =
        pkgs.writeScript "sshAsUser" ''
          user="$1"; shift
          exec ${pkgs.sudo}/bin/sudo -i -u "$user" \
            ${pkgs.openssh}/bin/ssh "$@"
        '';
      options =
        [
          "user"
          "uid=occam"
          "gid=users"
          "allow_other"
          "exec" # Override "user"'s noexec
          "noatime"
          "nosuid"
          "_netdev"
          "ssh_command=${sshAsUser}\\040occam"
          "noauto"
          "x-gvfs-hide"
          "x-systemd.automount"
          #"Compression=yes" # YMMV
          # Disconnect approximately 2*15=30 seconds after a network failure
          "ServerAliveCountMax=1"
          "ServerAliveInterval=15"
          "dir_cache=no"
          #"reconnect"
        ];
    in
    {
      "/home/occam/documents/code/tandem/wildflower" = {
        device = "${pkgs.sshfs-fuse}/bin/sshfs#wildflower@npona.wildflower.org:/var/www/vhosts/plants.wildflower.org/html/wp-content/themes/npona";
        fsType = "fuse";
        inherit options;
      };
    };
  systemd.automounts = [
    { where = "/home/occam/documents/code/tandem/wildflower"; automountConfig.TimeoutIdleSec = "5 min"; }
  ];


  };
}
