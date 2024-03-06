{ pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    zsh fzf exa
	];

	programs.zsh = {
	    enable = true;
	    enableCompletion = true;
	    enableAutosuggestions = true;
	    enableSyntaxHighlighting = true;

	    history = {
	        save = 10000;
		size = 10000;
		path = "$HOME/.cache/zsh_history";
	    };

	    shellAliases = {
	        l = "exa -ac --icons";
	    };
	};
    };
}
