{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./sway.nix
  ];
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gtk
    configure-gtk
  ];

  environment.variables = {
    NIXOS_CONFIG = "$HOME/dotfiles/nixos/configuration.nix";
    NIXOS_CONFIG_DIR = "$HOME/dotfiles";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
    GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
    MOZ_ENABLE_WAYLAND = "1";
    DISABLE_QT5_COMPAT = "0";
    DIRENV_LOG_FORMAT = "";

    XDG_DESKTOP_DIR = "$HOME/misc";
    XDG_PUBLICSHARE_DIR = "$HOME/misc";
    XDG_TEMPLATES_DIR = "$HOME/misc";
    XDG_DOWNLOAD_DIR = "$HOME/downloads";
    XDG_DOCUMENTS_DIR = "$HOME/documents";
    XDG_MUSIC_DIR = "$HOME/documents/music";
    XDG_PICTURES_DIR = "$HOME/documents/pictures";
    XDG_VIDEOS_DIR = "$HOME/documents/videos";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  # Let wm access monitor light
  programs.light.enable = true;

  # Setup sway
  security.polkit.enable = true;

  # Enable the X11 windowing system for xwayland
  services.xserver.enable = true;
}
