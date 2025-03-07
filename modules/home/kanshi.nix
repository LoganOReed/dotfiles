{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.kanshi;
in {
  options.my.kanshi = {enable = mkEnableOption "kanshi";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kanshi
    ];
    services.kanshi = {
      enable = true;
      profiles = {
        blade = {
          outputs = [
          {
            criteria = "AOC 2590G4 0x0001E45A";
            mode = "1920x1080@144.001Hz";
            position = "0,0";
          }
          {
            criteria = "AOC 2590G4 0x0001BD00";
            mode = "1920x1080@144.001Hz";
            position = "1920,0";
          }
          {
            criteria = "Ancor Communications Inc ASUS VS228 H8LMTF161534";
            mode = "1920x1080@60.000Hz";
            position = "3840,0";
            transform = "270";
          }
          ];
        };
        razor = {
          outputs = [
          {
            criteria = "BOE 0x0932 Unknown";
            mode = "1920x1080@60.003Hz";
            position = "0,0";
          }
          ];
        };
      };
    };
  };
}
