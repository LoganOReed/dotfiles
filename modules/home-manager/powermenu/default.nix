{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.powermenu;
  rofi-powermenu = pkgs.writeShellScriptBin "rofi-powermenu" ''${builtins.readFile ./powermenu.sh}'';
in {
  options.modules.powermenu = {enable = mkEnableOption "powermenu";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-powermenu
      tofi
      swaybg
      wlsunset
      wl-clipboard
      hyprland
      pavucontrol
      hyprpicker
      cliphist
    ];
    home.file.".config/rofi/confirm.rasi".source = ./confirm.rasi;
    home.file.".config/rofi/style.rasi".source = ./style.rasi;
  };
}
