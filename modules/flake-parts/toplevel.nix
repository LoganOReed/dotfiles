# Top-level flake glue to get our configuration working
{inputs, ...}: {
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];
  perSystem = {
    self',
    pkgs,
    ...
  }: {
    # For 'nix fmt'
    formatter = pkgs.alejandra;

    # Enables 'nix run' to activate.
    packages.default = self'.packages.activate;


  };
  # debug = true;
}
