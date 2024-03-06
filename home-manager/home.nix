# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  colorScheme = inputs.nix-colors.colorSchemes.dracula;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # DONE: Set your username
  home = {
    username = "occam";
    homeDirectory = "/home/occam";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs; [

  neofetch
  btop

  # archives
  zip
  xz
  unzip
  p7zip

  firefox


  # utils
  ripgrep # recursively searches directories for a regex pattern
  #eza # A modern replacement for ‘ls’
  #fzf # A command-line fuzzy finder
  manix # CLI Nix Documentation Search
  wev # check keycodes

  ];


  # Dracula Cursor

home.pointerCursor = 
    let 
      getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          name = name;
          size = 48;
          package = 
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${pkgs.fetchzip {
                url = url;
                hash = hash;
              }} $out/share/icons/${name}
          '';
        };
    in
      getFrom 
        "https://github.com/dracula/gtk/releases/download/v4.0.0/Dracula-cursors.tar.xz"
        "sha256-FCjsCGiaDqWisNe7cMgkKv1LLye6OLBOfhtRnkmXsnY="
        "Dracula-cursors";


  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Logan Reed";
    userEmail = "me@loganreed.org";
  };

  # Enable hyprland
  modules.hyprland.enable = true;
  modules.tofi.enable = true;

  modules.zsh.enable = true;
  modules.kitty.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
