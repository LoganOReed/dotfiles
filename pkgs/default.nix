# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  monolisa = pkgs.callPackage ./monolisa {};

  vim-sway-nav = pkgs.writeShellScriptBin "vim-sway-nav" ''
    # vim-sway-nav - Use the same bindings to move focus between sway windows and
    # vim splits. Requires the accompanying vim plugin.

    dir="$1"

    case "$dir" in
        up) ;;
        right) ;;
        down) ;;
        left) ;;
        *)
            echo "USAGE: $0 up|right|down|left"
            exit 1
    esac

    get_descendant_vim_pid() {
        pid="$1"
        terms="$2"

        if grep -iqE '^g?(view|n?vim?x?)(diff)?$' "/proc/$pid/comm"; then
            if embed_pid="$(pgrep --parent "$pid" --full 'nvim --embed')"; then
                echo "$embed_pid"
            else
                echo "$pid"
            fi

            return 0
        fi

        for child in $(pgrep --runstates D,I,R,S --terminal "$terms" --parent "$pid"); do
            if get_descendant_vim_pid "$child" "$terms"; then
                # already echo'd PID in recursive call
                return 0
            fi
        done

        return 1
    }

    if focused_pid="$(swaymsg -t get_tree | ${pkgs.jq}/bin/jq -e '.. | select(.focused? == true).pid')"; then
        terms="$(find /dev/pts -type c -not -name ptmx | sed s#^/dev/## | tr '\n' ,)"
        if vim_pid="$(get_descendant_vim_pid "$focused_pid" "$terms")"; then
            servername_file="''${XDG_RUNTIME_DIR:-/tmp}/vim-sway-nav.$vim_pid.servername"
            read -r program servername <"$servername_file"

            if [ "$program" = vim ]; then
                serverarg=--servername
            elif [ "$program" = nvim ]; then
                serverarg=--server
            fi

            if [ -n "$serverarg" ] && [ -n "$servername" ]; then
                "$program" "$serverarg" "$servername" \
                    --remote-expr "VimSwayNav('$dir')" >/dev/null 2>&1 \
                    && exit 0
            fi
        fi
    fi

    swaymsg focus "$dir"
  '';

  # NOTE: allows screen sharing

  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };

  Dracula-cursors = pkgs.runCommand "moveUp" {} ''
    mkdir -p $out/share/icons
    ln -s ${pkgs.fetchzip {
      url = "https://github.com/dracula/gtk/releases/download/v4.0.0/Dracula-cursors.tar.xz";
      hash = "sha256-FCjsCGiaDqWisNe7cMgkKv1LLye6OLBOfhtRnkmXsnY=";
    }} $out/share/icons/Dracula-cursors
  '';
}
