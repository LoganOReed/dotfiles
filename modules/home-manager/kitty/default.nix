

{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.programs.kitty;


in {
    options.programs.kitty= { enable = mkEnableOption "kitty"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    kitty
	];

	programs.kitty = {
	  shellIntegration.enableZshIntegration = true;

	  # Basically just kitty.conf in nixlang
	  settings = {
	    font_family = "Iosevka Comfy";
	    italic_font = "auto";
	    bold_font = "auto";
	    font_size = 16;
	    enable_audio_bell = "no";
	  };
	};
    };
}
