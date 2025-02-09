{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.git;
in {
  options.my.git = {enable = lib.mkEnableOption "git";};
  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        userName = "LoganOReed";
        userEmail = "me@loganreed.org";
        ignores = ["*~" "*.swp"];
        aliases = {
          ci = "commit";
        };
        extraConfig = {
          init.defaultBranch = "main";
          # init.defaultBranch = "master";
          # pull.rebase = "false";
        };
      };
      lazygit.enable = true;
    };
  };
}
