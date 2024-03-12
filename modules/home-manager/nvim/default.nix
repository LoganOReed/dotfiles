{ pkgs, lib, config, ... }:

with lib;
let 

  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withAllGrammars);

  cfg = config.modules.nvim;
in {
    options.modules.nvim= { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	 lazygit php83Packages.composer
   ripgrep fd lua-language-server
   go php lua54Packages.luarocks zulu17
   julia python311Packages.pip lua
   python310Packages.pynvim
	];
      home.file.".config/nvim" = {
        source = ./nvim;
        recursive = true;
      };
        home.file.".snippets" = {
          source = ./snippets;
          recursive = true;
        };
        # Treesitter is configured as a locally developed module in lazy.nvim
        # we hardcode a symlink here so that we can refer to it in our lazy config
        home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
          recursive = true;
          source = treesitterWithGrammars;
        };
        programs.zsh = {
            initExtra = ''
                export EDITOR="nvim"
            '';
        };

        programs.neovim = {
            enable = true;
            # package = pkgs.neovim;
            vimAlias = true;
            coc.enable = false;
            withNodeJs = true;
	};
    };
}


