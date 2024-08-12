# local access: http://127.0.0.1:8384/
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.syncthing;
in {
  options.modules.syncthing = {enable = mkEnableOption "syncthing";};
  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    # ];

    sops.secrets."syncthing/key".owner = config.users.users.occam.name;
    sops.templates."synckey".content = ''${config.sops.placeholder."syncthing/key"}'';
    # sops.templates."synckey".owner = config.users.users.occam.name;
    sops.secrets."syncthing/cert".owner = config.users.users.occam.name;
    sops.templates."synccert".content = ''${config.sops.placeholder."syncthing/cert"}'';
    # sops.templates."synccert".owner = config.users.users.occam.name;

    services = {
      syncthing = {
        enable = true;
        user = "occam";
        # dataDir = "/home/occam/misc";
        openDefaultPorts = true;
        # configDir = "/home/occam/.config/syncthing";
        key = ''${config.sops.templates."synckey".path}'';
        cert = ''${config.sops.templates."synccert".path}'';
        overrideDevices = true; # overrides any devices added or deleted through the WebUI
        overrideFolders = true; # overrides any folders added or deleted through the WebUI
        # guiAddress = "0.0.0.0:8384";
        settings = {
          devices = {
            "desktop" = {id = "AXRXWX6-4N3XCVB-2HMUK7T-YNBTDKE-I7W6B46-ERZFHBO-LVFCQ3T-7JQ5SA4";};
            "servo" = {id = "C4FLKEL-RQEUMUS-7D22WHU-FWZ7CUK-BRU4IFY-BPTFNFJ-YOAT5D4-7SCXFQA";};
            # "coredns-server" = { id = "REALLY-LONG-COREDNS-SERVER-SYNCTHING-KEY-HERE"; };
          };
          folders = {
            "music" = {
              # Name of folder in Syncthing, also the folder ID
              path = "/home/occam/documents/music"; # Which folder to add to Syncthing
              devices = ["desktop" "servo"]; # Which devices to share the folder with
            };
            # "coredns-config" = {
            #   path = "/data/coredns-config";
            #   devices = [ "coredns-server" ];
            #   versioning = {
            #     type = "simple";
            #     params = {
            #       keep = "10";
            #     };
            #   };
            # };
          };
        };
      };
    };

    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  };
}
