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
  imports =
    [
      # If you want to use modules your own flake exports (from modules/nixos):

      # Or modules from other flakes (such as nixos-hardware):
      # inputs.hardware.nixosModules.common-cpu-amd
      # inputs.hardware.nixosModules.common-ssd
      inputs.sops-nix.nixosModules.sops

      # You can also split up your configuration and import pieces of it here:
      # ./users.nix
      ./../shared/yubikey-pam.nix

      # Import your generated (nixos-generate-config) hardware configuration
      ./hardware-configuration.nix
      ./disk-config.nix
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  modules = {
    anki.enable = true;
#TODO: FIX wireguard and syncthing, probably due to sops
    # wireguard.enable = true;
    # music.enable = true;
    # syncthing.enable = true;
    # ssh.enable = true;
    # disabled as it heavily lags when trying to access the directory
    # sshfs.enable = true;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      occam = import ../../home-manager/razor;
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
      allowed-users = ["occam"];
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

  # Set environment variables
  # NOTE: I'm setting this so ~/Downloads stops showing up
  environment.variables = {
    NIXOS_CONFIG = "$HOME/dotfiles/nixos/configuration.nix";
    NIXOS_CONFIG_DIR = "$HOME/dotfiles";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
    GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
    MOZ_ENABLE_WAYLAND = "1";
    DISABLE_QT5_COMPAT = "0";
    DIRENV_LOG_FORMAT = "";

    XDG_DESKTOP_DIR = "$HOME/misc";
    XDG_PUBLICSHARE_DIR = "$HOME/misc";
    XDG_TEMPLATES_DIR = "$HOME/misc";
    XDG_DOWNLOAD_DIR = "$HOME/downloads";
    XDG_DOCUMENTS_DIR = "$HOME/documents";
    XDG_MUSIC_DIR = "$HOME/documents/music";
    XDG_PICTURES_DIR = "$HOME/documents/pictures";
    XDG_VIDEOS_DIR = "$HOME/documents/videos";
  };

  environment.sessionVariables = {
    FLAKE = "/home/occam/dotfiles";
    EDITOR = "nvim";
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
    acpi
    wget
    git
    kitty
    xclip
    wl-clipboard
    bashmount
    firefox
    sops
    age
    ssh-to-age
    networkmanagerapplet
    thunderbird
    stable.gimp-with-plugins
    # obs-studio
    stable.inkscape
    pulseaudio
    qbittorrent
    nix-inspect
  ];

  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];

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
        '';
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
  '';

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # Let wm access monitor light
  programs.light.enable = true;

  # Setup sway
  security.polkit.enable = true;
  

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # hardware.pulseaudio.enable = true;
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
      monolisa
      iosevka-comfy.comfy
      iosevka-comfy.comfy-motion
      noto-fonts-color-emoji
      font-awesome
      powerline-symbols
      openmoji-color
      nerd-fonts.iosevka
    ];
  };

  # Stylix Config
  stylix.enable = true;
  stylix.image = ../../pics/nixos-wallpaper2.png;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

  stylix.fonts = {
    serif = {
      package = pkgs.iosevka-comfy.comfy-motion;
      name = "Iosevka Comfy Serif";
      # package = pkgs.monolisa;
      # name = "MonoLisa Nerd Font";
    };

    sansSerif = {
      package = pkgs.iosevka-comfy.comfy;
      name = "Iosevka Comfy Sans";
      # package = pkgs.monolisa;
      # name = "MonoLisa Nerd Font";
    };

    monospace = {
      # package = pkgs.iosevka-comfy.comfy;
      # name = "Iosevka Comfy Sans";
      package = pkgs.monolisa;
      name = "MonoLisa Nerd Font";
    };

    emoji = {
      # package = pkgs.noto-fonts-color-emoji;
      # name = "Noto Color Emoji";
      package = pkgs.monolisa;
      name = "MonoLisa Nerd Font";
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

  # Secrets and such
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/occam/.config/sops/age/keys.txt";

  sops.secrets."razor/occam".neededForUsers = true;
  sops.secrets."razor/wireguard/mullvad" = {};
  sops.secrets."razor/wireguard/private_key" = {};
  sops.secrets."razor/wireguard/address" = {};
  sops.secrets."razor/wireguard/public_key" = {};
  sops.secrets."razor/wireguard/endpoint" = {};
  sops.secrets."bitwarden/url".owner = config.users.users.occam.name;
  sops.secrets."bitwarden/api/client_id".owner = config.users.users.occam.name;
  sops.secrets."bitwarden/api/client_secret".owner = config.users.users.occam.name;

  # NOTE: END OF WHOLLY CUSTOM STUFF

  networking.hostName = "razor";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.users = {
    occam = {
      hashedPasswordFile = config.sops.secrets."razor/occam".path;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # Desktop
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyXa8tn7dqVcTCaKSOvBXn9UX5H7lcN1wNdDb8wMik6 occam@blade"
        # laptop
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfmahPLv3UWKpmSP1Ufx+LWgLAao9uNUy/CjPT9w+LN me@loganreed.org"
        #servo
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKorXdfBVr77CHWdCSywtTECIDmB1uUR6tGi1dHSFuNU me@loganreed.org"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["networkmanager" "wheel" "video" "audio" "input"];
      shell = pkgs.zsh;
    };
  };

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=60
  '';


# To double check it isn't conflicting with tlp
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
  services.thermald.enable = true;

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
