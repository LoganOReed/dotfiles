{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.zathura;
in {
  options.my.zathura = {enable = mkEnableOption "zathura";};
  config = mkIf cfg.enable {
    #home.packages = with pkgs; [
    #];
    programs.zathura = {
      enable = true;
    };
  };
}
