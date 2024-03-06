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
	font = JetBrains Mono
	font-size=14
	# style
	border-width = 1
	outline-width = 1
	height = 450
	width = 450
	padding-left = 30
	padding-top = 20
	prompt-padding = 5
	result-spacing = 5
	# colors

	placeholder-color = #928374
	background-color = #1B1B1B
	border-color = #458588
	outline-color= #000000
	selection-color = #458588
	text-color = #BDAE93
	prompt-color = #928374
      '';
    };

}



