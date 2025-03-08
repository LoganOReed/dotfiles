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
    ./boot.nix
    ./nix.nix
    ./yubikey.nix
    ./secrets.nix
  ];
  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=60
  '';

  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };
}
