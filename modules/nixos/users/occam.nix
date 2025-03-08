# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{flake, config, pkgs, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.occam = {
    hashedPasswordFile = config.age.secrets."github-ssh-key".path;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      # Desktop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyXa8tn7dqVcTCaKSOvBXn9UX5H7lcN1wNdDb8wMik6 occam@blade"
      # laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfmahPLv3UWKpmSP1Ufx+LWgLAao9uNUy/CjPT9w+LN me@loganreed.org"
      #servo
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKorXdfBVr77CHWdCSywtTECIDmB1uUR6tGi1dHSFuNU me@loganreed.org"
    ];
    extraGroups = ["networkmanager" "wheel" "video" "audio" "input"];
    shell = pkgs.zsh;
  };

  # TODO: Make shell modulable
  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];

# Enable home-manager for "occam" user
  home-manager.users."occam" = {
    imports = [(self + /configurations/home/occam.nix)];
  };

  # FLAKE is directory of config
  environment.sessionVariables = {
    FLAKE = "/home/occam/dotfiles";
    EDITOR = "nvim";
  };

  nix.settings.allowed-users = ["occam"];
  # These users can add Nix caches.
  nix.settings.trusted-users = ["root" "occam"];

  # nh os switch
  programs.nh = {
    flake = "/home/occam/dotfiles";
  };

}
