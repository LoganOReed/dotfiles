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

      # Import your generated (nixos-generate-config) hardware configuration
      ./hardware-configuration.nix
      ./disk-config.nix
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  modules = {
    # wireguard.enable = true;
    # music.enable = true;
    # syncthing.enable = true;
    # disabled as it heavily lags when trying to access the directory
    # sshfs.enable = true;
    homeserver.enable = true;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      occam = import ../../home-manager/home.nix;
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

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      #"/home/occam/dotfiles"
      #"/home/occam/.ssh"
      "/var/log"
      "/storage"
      #"/var/lib/bluetooth"
      "/var/lib/nixos"
      #"/var/lib/systemd/coredump"
      #"/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/var/keys/secret_file";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
    ];
  };

  # required for persistence with home manager
  programs.fuse.userAllowOther = true;

  # TODO: Reimplement this once setup is done

  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   mkdir /btrfs_tmp
  #   mount /dev/root_vg/root /btrfs_tmp
  #   if [[ -e /btrfs_tmp/root ]]; then
  #       mkdir -p /btrfs_tmp/old_roots
  #       timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #       mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #   fi
  #
  #   delete_subvolume_recursively() {
  #       IFS=$'\n'
  #       for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #           delete_subvolume_recursively "/btrfs_tmp/$i"
  #       done
  #       btrfs subvolume delete "$1"
  #   }
  #
  #   for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #       delete_subvolume_recursively "$i"
  #   done
  #
  #   btrfs subvolume create /btrfs_tmp/root
  #   umount /btrfs_tmp
  # '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["storage"];
  services.zfs.autoScrub.enable = true;
  boot.zfs.forceImportRoot = false;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  networking.hostName = "servo"; # Define your hostname.
  networking.hostId = "2d87f0cc"; # Define your hostname.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    acpi
    tlp
    wget
    git
    kitty
    xclip
    wl-clipboard
    bashmount
    firefox
    sops
    networkmanagerapplet
    thunderbird
    zfs
    neovim
    # gimp-with-plugins
    # obs-studio
    pulseaudio
    # qbittorrent
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
  security.pam.services.swaylock = {
    text = "auth include login";
  };

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

  # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  # services.pipewire = {
  # enable = true;
  #alsa.enable = true;
  #alsa.support32Bit = true;
  #pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
  # };

  # Disable bluetooth, enable pulseaudio, enable opengl (for Wayland)
  #hardware = {
  #  bluetooth.enable = true;
  #  bluetooth.powerOnBoot = true;
  #graphics = {
  #  enable32Bit = true;
  #  enable = true;
  #};
  #};

  # Install fonts
  fonts = {
    packages = with pkgs; [
      iosevka-comfy.comfy
      iosevka-comfy.comfy-motion
      noto-fonts-color-emoji
      font-awesome
      powerline-symbols
      openmoji-color
      (nerdfonts.override {fonts = ["Iosevka"];})
    ];
  };

  # Stylix Config
  stylix.enable = true;
  stylix.image = ../../pics/RainbowDracula.png;
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

  # Secrets and such
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/occam/.config/sops/age/keys.txt";

  sops.secrets."server/occam".neededForUsers = true;
  sops.secrets."razor/wireguard/mullvad" = {};
  sops.secrets."bitwarden/url".owner = config.users.users.occam.name;
  sops.secrets."bitwarden/api/client_id".owner = config.users.users.occam.name;
  sops.secrets."bitwarden/api/client_secret".owner = config.users.users.occam.name;

  # NOTE: END OF WHOLLY CUSTOM STUFF

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.users = {
    occam = {
      hashedPasswordFile = config.sops.secrets."server/occam".path;
      # initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # Desktop
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCs+NG11ApioRAmRvOkinKkv8yN2u36bXqPqwgSX3PgiDv2n0VgLQvPjOr5/sxcinsJY/fNXAaHbMME5FtlxNZCX+dNbhlO7LCAyKVFEm2zkPteI2MpHDe+B4BP1g0IGJr/XyGy5TaUgGdVYqjyXxT09TtBdybYHf4ORLzEl+r7C3g5k9IHKkujnkZZK/YGEotexg6JISWJ68YRuZcOt5PXncHXAzA6gQFZBfW0MJCcWxOo5indO4FLt60bM1dam4hPH//hilGsAKQAhRRxB3dmDz+m0dm3aj7MDxD4hhLaHw6rSOa/c/npDtsGIyuyFDzP84uVV0i6MP3qfBxfame4cEXpENZuMv5LhIr2HohU2hpz6pEbieebnZZrR+aobqupl5/UI9Z4aQP5WnleQZyaAyAMr3r3o0MZpaF+8yfW5ASsIp2RsEeiv/CJBnFRoKUih2npQMFTYhtnCGjSY9/IhjDmR6QlPxzytC324B61Ms03ztZNhahGpQhevKypMT0= occam@blade"
        # laptop
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfmahPLv3UWKpmSP1Ufx+LWgLAao9uNUy/CjPT9w+LN me@loganreed.org"
        #servo
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKorXdfBVr77CHWdCSywtTECIDmB1uUR6tGi1dHSFuNU me@loganreed.org"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["networkmanager" "wheel" "video" "audio" "input" "docker"];
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
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.configurationLimit = 10;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
