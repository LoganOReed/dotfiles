{ pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    zsh fzf eza
	];

	programs.zsh = {
	    enable = true;
	    enableCompletion = true;
	    enableAutosuggestions = true;
	    syntaxHighlighting.enable = true;

	    initExtra = ''
	        PROMPT="%F{blue}%m %~%b "$'\n'"%(?.%F{green}%Bλ%b |.%F{red}?) %f"
		bindkey '^ ' autosuggest-accept
	    '';

	    history = {
	        save = 10000;
		size = 10000;
		path = "$HOME/.cache/zsh_history";
	    };

	    shellAliases = {
	        l = "eza -a --icons";
		rebuild = "sudo nixos-rebuild switch --flake . --fast";
		n = "nvim";
	    };
	};
    };
}
