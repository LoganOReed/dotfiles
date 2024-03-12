{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.modules.nvim;
in {
    options.modules.nvim= { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {
	#home.packages = with pkgs; [
	# gnumake cmake clangStdenv clang ccls
	#];
        home.file.".config/nvim" = {
	  source = ./nvim;
	  recursive = true;
	};
        home.file.".snippets" = {
          source = ./snippets;
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

