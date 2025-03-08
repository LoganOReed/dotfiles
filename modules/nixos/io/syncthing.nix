# local access: http://127.0.0.1:8384/
{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (flake.config) me;
in
{
    # environment.systemPackages = with pkgs; [
    # ];
    services.syncthing = {
      enable = true;
      systemService = true;
      user = "${me.username}";
      group = "users";
      dataDir = "/home/${me.username}";  # default location for new folders
      configDir = "/home/${me.username}/.config/syncthing";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      settings.gui = {
        user = "${config.networking.hostName}";
        # passwordFile = lib.mkIf (host == "razor") config.age.secrets."syncthing-gui-password-razor".path;
        passwordFile = config.age.secrets."syncthing-gui-password-${config.networking.hostName}".path;
      };
      settings = {

        devices = {
          "ipad" = { id = "RAKNRHN-76DSQJA-MB6HG5R-Y74PYLA-FJAUWEI-FLR6H7X-22LVNFG-7SSZKQL"; };
          # nothing is set if mkIf evaluates to false
          "razor" = lib.mkIf (config.networking.hostName != "razor") {id = "H4XHEY7-LAXMMD3-EBX5YTR-2RQLIMK-JEBTVVM-KJYYGDG-M75DCIE-K3PYWQ2";};
          "blade" = lib.mkIf (config.networking.hostName != "blade") {id = "SY6BIYE-KECKE4W-ELMV3D2-XLEFNDQ-Q347PXG-T35BL3L-ZWS54VJ-FU5WDAI";};
          # "device2" = { id = "DEVICE-ID-GOES-HERE"; };
        };
        folders = lib.mkMerge [
          # This fuckery is using dropbox and notability's in built backup system, which I force syncthing into
          # I'm sure it will break at some point and I'll have no idea how to fix it.
          {
            "notability" = {
              path = "/home/${me.username}/documents/notes/notability";
              devices = [ "ipad" ];
            };

          }
          (lib.mkIf ("${config.networking.hostName}" == "razor")
             {

              # https://nicolasshu.com/zotero_and_papis.html
              "stacks" = {
                path = "/home/${me.username}/documents/library/stacks";
                devices = [ "ipad" "blade" ];
              };
              "zotero" = {
                path = "/home/${me.username}/documents/library/zotero";
                devices = [ "ipad" "blade" ];
              };


              "music" = {
                path = "/home/${me.username}/documents/music";
                devices = ["blade"];
              };

          })
          (lib.mkIf ("${config.networking.hostName}" == "blade") {

              # https://nicolasshu.com/zotero_and_papis.html
              "stacks" = {
                path = "/home/${me.username}/documents/library/stacks";
                devices = [ "razor" ];
              };
              "zotero" = {
                path = "/home/${me.username}/documents/library/zotero";
                devices = [ "razor" ];
              };

              "music" = {
                path = "/home/${me.username}/documents/music";
                devices = ["razor"];
              };
          })
        ];

          # "Example" = {
          #   path = "/home/myusername/Example";
          #   devices = [ "device1" ];
          #   # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          #   ignorePerms = false;
          # };
      };
    };
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}
