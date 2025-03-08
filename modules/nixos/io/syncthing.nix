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
        password = "password";
      };
      settings = {

        devices = {
          "ipad" = { id = "RAKNRHN-76DSQJA-MB6HG5R-Y74PYLA-FJAUWEI-FLR6H7X-22LVNFG-7SSZKQL"; };
          # "device2" = { id = "DEVICE-ID-GOES-HERE"; };
        };
        folders = {
          # This fuckery is using dropbox and notability's in built backup system, which I force syncthing into
          # I'm sure it will break at some point and I'll have no idea how to fix it.
          "notability" = {
            path = "/home/occam/documents/notes/notability";
            devices = [ "ipad" ];
          };
          # "Example" = {
          #   path = "/home/myusername/Example";
          #   devices = [ "device1" ];
          #   # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          #   ignorePerms = false;
          # };
        };
      };
    };
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}
