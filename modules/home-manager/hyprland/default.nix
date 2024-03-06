


{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.programs.hyprland;


in {
    options.programs.hyprland= { enable = mkEnableOption "hyprland"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    wofi swaybg wlsunset wl-clipboard hyprland
	];

        home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
    };
}
