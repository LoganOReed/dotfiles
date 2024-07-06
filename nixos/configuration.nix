# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./disk-config.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      occam = import ../home-manager/home.nix;
    };
  };


  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

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
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      allowed-users = [ "occam" ];
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than-7d";
    # };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration

  environment.sessionVariables = {
    FLAKE = "/home/occam/dotfiles";
  };

    # nix-helper
    # nh os switch
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 10";
      flake = "/home/occam/dotfiles";
    };




  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    bluetuith
    acpi
    tlp
    wget
    git
    kitty
    xclip
    wl-clipboard
    bashmount
    firefox
  ];

  programs.zsh.enable = true;




   # A key remapping daemon for linux.
   # https://github.com/rvaiya/keyd
   services.keyd = {
     enable = true;
     keyboards = {
       default = {
         settings = {
           main = {
             # overloads the capslock key to function as both escape (when tapped) and control (when held)
             capslock = "overload(control, esc)";
           };
         };
       };
     };
   };


  # Enable the X11 windowing system for xwayland
  #services.xserver.enable = true;

  services.greetd = {
    enable = true;
    settings = {
     default_session = {
       user = "occam";
       command = ''
      ${pkgs.greetd.tuigreet}/bin/tuigreet \
        --time \
        --asterisks \
        --user-menu \
        --cmd sway
    '';};
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
  '';

  # Let wm access monitor light
  programs.light.enable = true;

  # Setup sway
  security.polkit.enable = true;
  security.pam.services.swaylock = {
  	text = "auth include login";
  };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };


  # Disable bluetooth, enable pulseaudio, enable opengl (for Wayland)
  hardware = {
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
      graphics = {
        enable32Bit = true;
        enable = true;
      };
    };

  # Install fonts
  fonts = {
      packages = with pkgs; [
          iosevka-comfy.comfy
          iosevka-comfy.comfy-motion
          noto-fonts-color-emoji
          font-awesome
          powerline-symbols
          openmoji-color
          (nerdfonts.override { fonts = [ "Iosevka" ]; })
      ];
  };


  # Stylix Config
  stylix.enable = true;
  stylix.image = ../pics/RainbowDracula.png;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

  stylix.fonts = {
    serif = {
      package = pkgs.iosevka-comfy.comfy-motion;
      name = "Iosevka Comfy Serif";
    };

    sansSerif = {
      package = pkgs.iosevka-comfy.comfy;
      name = "Iosevka Comfy Sans";
    };

    monospace = {
      package = pkgs.iosevka-comfy.comfy;
      name = "Iosevka Comfy Sans";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };

  stylix.fonts.sizes = {
      applications = 12;
      terminal = 16;
      desktop = 12;
      popups = 12;
    };

  stylix.cursor.package = pkgs.Dracula-cursors;
  stylix.cursor.name = "Dracula-cursors";
  stylix.cursor.size = 16;

  stylix.polarity = "dark";



# NOTE: END OF WHOLLY CUSTOM STUFF

  networking.hostName = "razor";
  networking.networkmanager.enable = true;  

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.users = {
    occam = {
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "input"];
      shell = pkgs.zsh;
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
