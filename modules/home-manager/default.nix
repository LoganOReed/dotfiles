# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  hyprland = import ./hyprland;
  sway = import ./sway;
  zsh = import ./zsh;
  kitty = import ./kitty;
  tofi = import ./tofi;
  gbar = import ./gbar;
  nvim = import ./nvim;
  dunst = import ./dunst;
  xdg = import ./xdg;
}
