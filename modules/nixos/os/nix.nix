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

  programs.nh = {
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 10";
  };

  nix = {
    nixPath = ["nixpkgs=${flake.inputs.nixpkgs}"];
    registry.nixpkgs.flake = flake.inputs.nixpkgs;
    settings = {
      max-jobs = "auto";
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      allowed-users = ["occam"];
      flake-registry = "";
    };
    channel.enable = false;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      self.overlays.default

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # flake.inputs.nix-nvim.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  nixpkgs.config.allowUnfree = true;

}
