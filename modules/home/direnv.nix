{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.my.direnv;
in {
  options.my.direnv = {enable = mkEnableOption "direnv";};
  config = mkIf cfg.enable {
    # https://nixos.asia/en/direnv
    programs.direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
      config.global = {
        # Make direnv messages less verbose
        hide_env_diff = true;
      };
    };
  };
}
