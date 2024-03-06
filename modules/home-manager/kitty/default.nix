

{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.modules.kitty;


in {
    options.modules.kitty= { enable = mkEnableOption "kitty"; };
    config = mkIf cfg.enable {
	programs.kitty = with config.colorscheme.palette; {
	  enable = true;
	  shellIntegration.enableZshIntegration = true;

	  # Basically just kitty.conf in nixlang
	  settings = {
	    font_family = "Iosevka Comfy";
	    italic_font = "auto";
	    bold_font = "auto";
	    font_size = 12;
	    enable_audio_bell = "no";


	    # Base16 Dracula - kitty color config
            # Scheme by Mike Barkmin (http://github.com/mikebarkmin) based on Dracula Theme (http://github.com/dracula)
            background = "#${base00}";
            foreground = "#${base05}";
            selection_background = "#${base05}";
            selection_foreground = "#${base00}";
            url_color = "#${base04}";
            cursor = "#${base05}";
            active_border_color = "#${base03}";
            inactive_border_color = "#${base01}";
            active_tab_background = "#${base00}";
            active_tab_foreground = "#${base05}";
            inactive_tab_background = "#${base01}";
            inactive_tab_foreground = "#${base04}";
            tab_bar_background = "#${base01}";
            
            # normal
            color0 = "#${base00}";
            color1 = "#${base08}";
            color2 = "#${base0B}";
            color3 = "#${base0A}";
            color4 = "#${base04}";
            color5 = "#${base09}";
            color6 = "#${base0C}";
            color7 = "#${base05}";
            
            # bright
            color8 = "#${base03}";
            color9 = "#${base08}";
            color10 = "#${base0B}";
            color11 = "#${base0A}";
            color12 = "#${base04}";
            color13 = "#${base09}";
            color14 = "#${base0C}";
            color15 = "#${base07}";
            
            # extended base16 colors
            color16 = "#${base09}";
            color17 = "#${base0A}";
            color18 = "#${base01}";
            color19 = "#${base02}";
            color20 = "#${base04}";
            color21 = "#${base06}";
	  };
	};
    };
}
