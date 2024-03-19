{ pkgs, lib, config, ... }:

with lib;
let 

  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.bibtex
    p.comment
    p.c
    p.css
    p.cpp
    p.csv
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.haskell
    p.javascript
    p.jq
    p.json5
    p.json
    p.julia
    p.latex
    p.lua
    p.make
    p.markdown
    p.matlab
    p.nix
    p.php
    p.python
    p.rust
    p.sql
    p.toml
    p.typescript
    p.vue
    p.yaml
  ]));

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
   black
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
            package = pkgs.neovim-nightly;
            vimAlias = true;
            coc.enable = false;
            withNodeJs = true;
	};
    };
}


