# My NixOS Flake Config

Heavily based on [misterio77](https://github.com/Misterio77/nix-config/blob/main/README.md)

## Structure

- `flake.nix`: Entrypoint for hosts and home configurations. Also exposes a
  devshell for boostrapping (`nix develop` or `nix-shell`).
- `pics`: Images for various plugins, mainly wallpaper.
- `nixos`: NixOS Configurations, accessible via `nh os switch` or `nixos-rebuild --flake`.
  - TODO `common`: Shared configurations consumed by the machine-specific ones.
    - TODO `global`: Configurations that are globally applied to all my machines.
    - TODO `optional`: Opt-in configurations my machines can use.
  - `razor`: laptop
  - `blade`: pc
  - `servo`: server
- `home-manager`: TODO My Home-manager configuration, acessible via `home-manager --flake`
    - Each directory here is a "feature" each hm configuration can toggle, thus
      customizing my setup for each machine (be it a server, desktop, laptop,
      anything really).
- `modules`: A few actual modules (with options) I haven't upstreamed yet.
- `overlay`: Patches and version overrides for some packages. Accessible via
  `nix build`.
- `pkgs`: My custom packages. Also accessible via `nix build`. You can compose
  these into your own configuration by using my flake's overlay, or consume them through NUR.
- `templates`: A couple project templates for different languages. Accessible
  via `nix init`.


