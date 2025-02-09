{
  flake,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.my.nvim;
in {
  options.my.nvim = {enable = mkEnableOption "nvim";};
  config = mkIf cfg.enable {
    nixpkgs = {
      overlays = [
        flake.inputs.nix-nvim.overlays.default
      ];
    };

    home.packages = with pkgs; [
      nvim-pkg
      ripgrep
    ];

  };
}
