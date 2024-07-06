{ pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.tofi;
in {
    options.modules.tofi = { enable = mkEnableOption "tofi"; };

    config = mkIf cfg.enable {
      home.file.".config/tofi/config".text = with config.colorscheme.palette; ''
	# general
	prompt-text = " "
	hide-cursor = false
	history     = true

	# font
	font = Iosevka Comfy
	font-size=32
	# style
	border-width = 0
	outline-width = 0
	height = 100%
	width = 100%
	padding-left = 35% 
	padding-top = 17% 
	prompt-padding = 20
	result-spacing = 5
	# colors

	placeholder-color = #${base02}
	background-color = #${base00}
	border-color = #${base00}
	outline-color= #000000
	selection-color = #${base0A}
	text-color = #${base05}
	prompt-color = #${base08}
      '';
    };

}



