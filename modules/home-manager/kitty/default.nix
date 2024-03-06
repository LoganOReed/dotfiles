

{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.modules.kitty;


in {
    options.modules.kitty= { enable = mkEnableOption "kitty"; };
    config = mkIf cfg.enable {
	programs.kitty = {
	  enable = true;
	  shellIntegration.enableZshIntegration = true;

	  # Basically just kitty.conf in nixlang
	  settings = {
	    font_family = "Iosevka Comfy";
	    italic_font = "auto";
	    bold_font = "auto";
	    font_size = 12;
	    enable_audio_bell = "no";
	  };
	};
    };
}
