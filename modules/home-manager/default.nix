# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  beets = import ./beets;
  zsh = import ./zsh;
  sops = import ./sops;
  nvim = import ./nvim;
  direnv = import ./direnv;
  git = import ./git;
  gbar = import ./gbar;
  waybar = import ./waybar;
  kdeconnect = import ./kdeconnect;
  sway = import ./sway;
  kitty = import ./kitty;
  gpg = import ./gpg;
  hyprland = import ./hyprland;
  watson = import ./watson;
  xdg = import ./xdg;
  firefox = import ./firefox;
  qutebrowser = import ./qutebrowser;
  dunst = import ./dunst;
  eww = import ./eww;
  zathura = import ./zathura;
  tofi = import ./tofi;
  rofi = import ./rofi;
  i3 = import ./i3;
  lf = import ./lf;
  powermenu = import ./powermenu;
  bitwarden = import ./bitwarden;
  ncmpcpp = import ./ncmpcpp;
}
