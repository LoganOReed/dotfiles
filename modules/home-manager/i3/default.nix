{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.i3;
in {
  options.modules.i3 = {enable = mkEnableOption "i3";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      i3
      rofi # application launcher, the same as dmenu
      dunst # notification daemon
      i3blocks # status bar
      i3lock # default i3 screen locker
      xautolock # lock screen after some time
      i3status # provide information to i3bar
      i3-gaps # i3 with gaps
      picom # transparency and shadows
      feh # set wallpaper
      acpi # battery information
      arandr # screen layout manager
      dex # autostart applications
      xbindkeys # bind keys to commands
      xorg.xbacklight # control screen brightness
      xorg.xdpyinfo # get screen information
      sysstat # get system information
    ];
    home.file.".config/i3/config".source = ./config;
  };
}
