{
  pkgs,
  lib,
  config,
  sops,
  ...
}:
with lib; let
  cfg = config.modules.homeserver;
in {
  options.modules.homeserver = {enable = mkEnableOption "homeserver";};
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ctop
      docker-compose
    ];

    virtualisation.docker.storageDriver = "btrfs";
    virtualisation.docker.enable = true;

    users.users.occam.extraGroups = ["docker"];
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
