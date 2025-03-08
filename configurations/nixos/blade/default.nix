# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    inputs.agenix.nixosModules.default
    ./configuration.nix
  ];


  networking.hostName = "blade";
  system.stateVersion = "24.05"; # Did you read the comment?
}
