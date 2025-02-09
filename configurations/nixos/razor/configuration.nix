# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  flake,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (flake) config inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.default
    self.nixosModules.nh
    self.nixosModules.gui # system-wide sway stuff and stylix
    self.nixosModules.laptop




    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
  ];


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";




  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
}
