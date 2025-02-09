{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.xdg;
in {
  options.my.xdg = {enable = mkEnableOption "xdg";};
  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs = {
        documents = "${config.home.homeDirectory}/documents/";
        pictures = "${config.home.homeDirectory}/documents/pictures/";
        music = "${config.home.homeDirectory}/documents/music/";
        videos = "${config.home.homeDirectory}/documents/videos/";
        download = "${config.home.homeDirectory}/downloads/";
        desktop = "${config.home.homeDirectory}/misc/";
        publicShare = "${config.home.homeDirectory}/misc/";
        templates = "${config.home.homeDirectory}/misc/";
      };
    };
  };
}
