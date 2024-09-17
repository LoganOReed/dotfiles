{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.nvim;
in {
  options.modules.nvim = {enable = mkEnableOption "nvim";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # nvim-pkg is the default output of
      # https://github.com/LoganOReed/kickstart-nix.nvim
      # which is the flake I use to configure nvim
      nvim-pkg
      ripgrep
    ];

    home.file.".config/nvim/README.md".text = ''
    This directory exists specifically to make UltiSnipsEdit work.
    I believe this is needed since UltiSnips is full vim not nvim.
    '';

# LuaSnip is commented as im migrating away
# UltiSnips is commented bc i am using dotfiles dir
# specifically, instead of symlinking
    # home.file.".snippets/luasnip" = {
    #   source = ./luasnip;
    #   recursive = true;
    # };
    # home.file.".snippets/UltiSnips" = {
    #   source = ./UltiSnips;
    #   recursive = true;
    # };
  };
}
