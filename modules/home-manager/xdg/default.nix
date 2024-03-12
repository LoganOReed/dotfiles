{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.xdg;

in {
    options.modules.xdg = { enable = mkEnableOption "xdg"; };
    config = mkIf cfg.enable {
        xdg.userDirs = {
            enable = true;
            documents = "$HOME/documents/";
            download = "$HOME/downloads/";
            videos = "$HOME/misc/videos/";
            music = "$HOME/misc/music/";
            pictures = "$HOME/misc/pictures/";
            desktop = "$HOME/misc/";
            publicShare = "$HOME/misc/";
            templates = "$HOME/misc/";
        };
    };
}
