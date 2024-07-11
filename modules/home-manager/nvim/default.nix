{  lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.nvim;
in {
    options.modules.nvim = { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
          # nvim-pkg is the default output of 
          # https://github.com/LoganOReed/kickstart-nix.nvim
          # which is the flake I use to configure nvim
            nvim-pkg
            ripgrep
        ];

        home.file.".snippets/luasnip" = {
          source = ./luasnip;
          recursive = true;
          };

    };
}
