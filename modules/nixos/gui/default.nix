{pkgs, ...}: {
  imports = [
    # ./gnome.nix
    #TODO: Get rid of gnome
    ./wayland
    ./stylix
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [
    stable.gimp-with-plugins
    obs-studio
    stable.inkscape
    firefox
    qutebrowser
    thunderbird
    xclip
    wl-clipboard
    btop
    zotero
    zotero2papis
    papis
  ];
}
