{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.rofi;
in {
  options.my.rofi = {enable = mkEnableOption "rofi";};

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
    home.packages = with pkgs; [
      rofi-bluetooth
    ];
  };
}
