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
  imports =
    [
      # If you want to use modules your own flake exports (from modules/home-manager):
      # outputs.homeManagerModules.example

      # Or modules exported from other flakes (such as nix-colors):
      # inputs.nix-colors.homeManagerModules.default
      inputs.gBar.homeManagerModules.x86_64-linux.default
      inputs.sops-nix.homeManagerModules.sops
      # You can also split up your configuration and import pieces of it here:
      # ./nvim.nix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  # stylix.targets.kitty.enable = false;

  modules = {
    # gui
    # firefox.enable = true;
    qutebrowser.enable = true;
    sops.enable = true;
    kitty.enable = true;
    # eww.enable = true;
    dunst.enable = true;
    # hyprland.enable = true;
    sway.enable = true;
    lf.enable = true;
    # i3.enable = true;
    # gbar.enable = true;
    waybar.enable = true;
    tofi.enable = true;
    rofi.enable = true;
    zathura.enable = true;
    # bitwarden.enable = true;

    # cli
    nvim.enable = true;
    watson.enable = true;
    zsh.enable = true;
    git.enable = true;
    gpg.enable = true;
    ncmpcpp.enable = true;
    # beets.enable = true;
    kdeconnect.enable = true;
    direnv.enable = true;
    powermenu.enable = true;

    # system
    xdg.enable = true;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.kickstart-nix-nvim.overlays.default

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
    };
  };

  home = {
    username = "occam";
    homeDirectory = "/home/occam";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [
  #   grim  #screenshot
  #   slurp #screenshot
  #   wl-clipboard
  # ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
