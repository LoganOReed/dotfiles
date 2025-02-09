{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
    ./stylix.nix
  ];

  stylix.enable = true;
}
