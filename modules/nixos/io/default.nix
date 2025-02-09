# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    ./wifi.nix
    ./bluetooth.nix
    ./thumb.nix
    ./sound.nix
    ./syncthing.nix
  ];


  services.printing.enable = true;

}
