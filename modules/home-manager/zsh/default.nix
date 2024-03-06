{ pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    zsh fzf eza zoxide
	];

	programs.zoxide = {
	  enable = true;
	  enableZshIntegration = true;
	};

	programs.zsh = {
	    enable = true;
	    enableCompletion = true;
	    enableAutosuggestions = true;
	    syntaxHighlighting.enable = true;

	    initExtra = ''
		bindkey '^ ' autosuggest-accept
		prompt pure
	    '';

	    history = {
	        save = 10000;
		size = 10000;
		path = "$HOME/.cache/zsh_history";
	    };

	    shellAliases = {
	        l = "eza -a --icons";
		deploy = "sudo nixos-rebuild switch --flake .";
		n = "nvim";
	    };
	    plugins = [
	    {
	      name = "pure";
	      src = pkgs.fetchFromGitHub {
	        owner = "sindresorhus";
		repo = "pure";
		rev = "v1.23.0";
		sha256 = "sha256-BmQO4xqd/3QnpLUitD2obVxL0UulpboT8jGNEh4ri8k=";
	      };
	    }
	    ];
	};
    };
}
