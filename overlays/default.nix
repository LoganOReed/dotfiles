# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
  packages = self + /packages;
in
  self: super: {
    # Adding overlay from flake input
    watson-personal = inputs.watson-personal.packages."x86_64-linux".default;
    nvim-pkg = (inputs.nix-nvim.overlays.default self super).nvim-pkg;
    # example = pkgs.callPackage ./example { };
    monolisa = self.callPackage "${packages}/monolisa" {};
    Dracula-cursors = import "${packages}/Dracula-cursors.nix" self.pkgs;
    configure-gtk = self.callPackage "${packages}/configure-gtk.nix" {};
    dbus-sway-environment = self.callPackage "${packages}/dbus-sway-environment.nix" {};
    vim-sway-nav = self.callPackage "${packages}/vim-sway-nav.nix" {};
    qutebrowser = super.qutebrowser.override { enableWideVine = true; };

    zotero = self.callPackage "${packages}/zotero.nix" {};
    zotero2papis = self.callPackage "${packages}/zotero2papis.nix" {};

    





    stable = import inputs.nixpkgs-stable {
      system = self.system;
      config.allowUnfree = true;
    };

    ##
    ## TODO: Finish The rest of the overlays
    ##
  }
