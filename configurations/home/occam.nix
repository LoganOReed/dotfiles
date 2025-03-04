{
  flake,
  pkgs,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.default
  ];

  # my personal modules
  my = {
    # gui
    # firefox.enable = true;
    qutebrowser.enable = true;
    # anki.enable = true;
    kitty.enable = true;
    dunst.enable = true;
    # hyprland.enable = true;
    sway.enable = true;
    lf.enable = true;
    # i3.enable = true;
    # gbar.enable = true;
    waybar.enable = true;
    tofi.enable = true;
    rofi.enable = true;
    zathura.enable = true;
    # bitwarden.enable = true;

    # cli
    nvim.enable = true;
    watson.enable = true;
    zsh.enable = true;
    git.enable = true;
    # gpg.enable = true;
    ncmpcpp.enable = true;
    # beets.enable = true;
    direnv.enable = true;
    powermenu.enable = true;

    # system
    xdg.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.username = "occam";
  home.homeDirectory = lib.mkDefault "/${
    if pkgs.stdenv.isDarwin
    then "Users"
    else "home"
  }/occam";
  home.stateVersion = "24.11";
}
