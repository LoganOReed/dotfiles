{writeTextFile, ...}:
# NOTE: allows screen sharing
# bash script to let dbus know about important env variables and
# propogate them to relevent services run at the end of sway config
# see
# https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
writeTextFile {
  name = "dbus-sway-environment";
  destination = "/bin/dbus-sway-environment";
  executable = true;
  text = ''
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
    systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  '';
}
