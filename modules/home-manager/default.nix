# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  zsh = import ./zsh;
  nvim = import ./nvim;
  direnv = import ./direnv;
  git = import ./git;
  gbar = import ./gbar;
  waybar = import ./waybar;
  sway = import ./sway;
  kitty = import ./kitty;
  gpg = import ./gpg;
  hyprland = import ./hyprland;
  watson = import ./watson;
  xdg = import ./xdg;
  firefox = import ./firefox;
  dunst = import ./dunst;
  eww = import ./eww;
  zathura = import ./zathura;
  tofi = import ./tofi;
  i3 = import ./i3;
}
