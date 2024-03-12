{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.modules.nvim;
in {
    options.modules.nvim= { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {
        home.file.".config/nvim" = {
	  source = "nvim";
	  recursive = true;
	};
        programs.zsh = {
            initExtra = ''
                export EDITOR="nvim"
            '';
        };

        programs.neovim = {
            enable = true;
	    };
    };
}

