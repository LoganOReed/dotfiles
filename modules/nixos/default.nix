# This is your nixos configuration.
# For home configuration, see /modules/home/*
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
    ./common.nix
  ];

# TODO: Add this
# Allows ipad to become tablet, requires vpn to be down
# programs.weylus = {
#   enable = true;
#   openFirewall = true;
#   users = ["occam"];
# };


}
