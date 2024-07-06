{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.xdg;

in {
    options.modules.xdg = { enable = mkEnableOption "xdg"; };
    config = mkIf cfg.enable {
        xdg.userDirs = {
            enable = true;
            documents = "$HOME/documents/";
            pictures = "$HOME/documents/pictures/";
            music = "$HOME/documents/music/";
            videos = "$HOME/documents/videos/";
            download = "$HOME/downloads/";
            desktop = "$HOME/misc/";
            publicShare = "$HOME/misc/";
            templates = "$HOME/misc/";
        };
    };
}
