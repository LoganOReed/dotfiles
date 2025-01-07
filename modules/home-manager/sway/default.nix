{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.sway;
in {
  options.modules.sway = {enable = mkEnableOption "sway";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-wayland
      wlsunset
      pavucontrol
      swayidle
      wayland
      xwayland
      wl-clipboard
      mpv
      imv
      dbus-sway-environment
      configure-gtk
      vim-sway-nav
      rofi-bluetooth
    ];

    programs.btop = {
      enable = true;
      settings = {
        # color_theme = "Dracula";
        vim_keys = true;
        temp_scale = "fahrenheit";
      };
    };

    # enable sway window manager
    wayland.windowManager.sway = {
      enable = true;
      checkConfig = false;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
      xwayland = true;
      config = {
        terminal = "${pkgs.kitty}/bin/kitty";
        modifier = "Mod4";
        floating.modifier = "Mod4";
        # defined through stylix
        # fonts = {
        #   names = [ "Iosevka Comfy" "Iosevka Nerd Font" ];
        #   size = 16.0;
        # };

        # This seems to mess with swayfx specifics
        # window.border = 2;
        # window.titlebar = false;
        defaultWorkspace = "workspace 1";
        gaps = {
          smartGaps = true;
          smartBorders = "on";
          inner = 15;
          outer = 0;
        };
        bars = [
          {
            command = "waybar";
          }
        ];
        startup = [
          # {
          #   command = "systemctl --user restart waybar";
          #   always = true;
          # }
          {
            command = "--no-startup-id ${pkgs.autotiling}/bin/autotiling";
            always = true;
          }
          {
            command = "--no-startup-id ${pkgs.dunst}/bin/dunst";
            always = true;
          }
          # https://github.com/LandingEllipse/kitti3
          {
            command = "--no-startup-id ${pkgs.kitti3}/bin/kitti3 -n scratchcalc -p RC -s .35 1 -- ${pkgs.kalker}/bin/kalker";
            always = true;
          }
          {
            command = "--no-startup-id ${pkgs.kitti3}/bin/kitti3 -n scratchpad -p CC -s 0.6 0.6";
            always = true;
          }
          {command = "swaymsg workspace 2 && ${pkgs.qutebrowser}/bin/qutebrowser --class QuteBrowser";}
          {command = "swaymsg workspace 8 && ${pkgs.thunderbird}/bin/thunderbird --class Thunderbird";}
          {command = "${pkgs.dbus-sway-environment}/bin/dbus-sway-environment";}
          {command = "${pkgs.configure-gtk}/bin/configure-gtk";}
        ];

        assigns = {
          "2" = [{class = "QuteBrowser";}];
          "7" = [{class = "btop";}];
          "8" = [{class = "Thunderbird";}];
        };

        keybindings = let
          mod = config.wayland.windowManager.sway.config.modifier;
          term = config.wayland.windowManager.sway.config.terminal;
        in {
          # alphabetical

          # a
          "${mod}+b" = ''workspace 2; exec qutebrowser; focus'';
          "${mod}+Shift+b" = ''workspace 2; exec ${pkgs.firefox}/bin/firefox --class Firefox; focus'';
          "${mod}+c" = ''nop scratchcalc'';
          "${mod}+d" = ''exec --no-startup-id ${pkgs.tofi}/bin/tofi-drun --drun-launch=true'';
          "${mod}+e" = ''workspace 8; exec ${pkgs.thunderbird}/bin/thunderbird --class Thunderbird; focus'';
          "${mod}+f" = ''fullscreen toggle'';
          "${mod}+Shift+f" = ''floating toggle'';
          # g
          "${mod}+h" = ''exec vim-sway-nav left'';
          "${mod}+Shift+h" = ''move left 30'';
          "${mod}+Ctrl+h" = ''move workspace to output left'';
          "${mod}+i" = ''nop scratchpad'';
          "${mod}+j" = ''exec vim-sway-nav down'';
          "${mod}+Shift+j" = ''move down 30'';
          "${mod}+Ctrl+j" = ''focus child'';
          "${mod}+k" = ''exec vim-sway-nav up'';
          "${mod}+Shift+k" = ''move up 30'';
          "${mod}+Ctrl+k" = ''focus parent'';
          "${mod}+l" = ''exec vim-sway-nav right'';
          "${mod}+Shift+l" = ''move right 30'';
          "${mod}+Ctrl+l" = ''move workspace to output right'';
          "${mod}+m" = ''workspace 10; exec --no-startup-id ${term} -e ncmpcpp'';
          # TODO: Make work in wayland
          # "${mod}+Shift+m" = ''exec i3-input -F '[con_mark="%s"] focus' -l 1 -P 'Goto: ' '';

          #n
          #o
          #p
          "${mod}+q" = ''[con_id="__focused__" instance="^(?!dropdown_).*$"] kill'';
          # TODO: Fix Shift q for wayland
          "${mod}+Shift+q" = ''[con_id="__focused__" instance="^(?!dropdown_).*$"] exec --no-startup-id kill -9 `xdotool getwindowfocus getwindowpid`'';
          "${mod}+r" = ''exec --no-startup-id renoise'';
          #s
          "${mod}+t" = ''workspace 7; exec --no-startup-id ${term} -e ${pkgs.btop}/bin/btop --class btop; focus'';
          "${mod}+u" = ''[urgent=latest] focus'';
          "${mod}+v" = ''exec --no-startup-id ${pkgs.mpv}/bin/mpv /dev/video0'';
          #w
          #x
          #y
          #z

          # numerical
          "${mod}+1" = ''workspace 1'';
          "${mod}+2" = ''workspace 2'';
          "${mod}+3" = ''workspace 3'';
          "${mod}+4" = ''workspace 4'';
          "${mod}+5" = ''workspace 5'';
          "${mod}+6" = ''workspace 6'';
          "${mod}+7" = ''workspace 7'';
          "${mod}+8" = ''workspace 8'';
          "${mod}+9" = ''workspace 9'';
          "${mod}+0" = ''workspace 10'';
          "${mod}+Shift+1" = ''move container to workspace 1'';
          "${mod}+Shift+2" = ''move container to workspace 2'';
          "${mod}+Shift+3" = ''move container to workspace 3'';
          "${mod}+Shift+4" = ''move container to workspace 4'';
          "${mod}+Shift+5" = ''move container to workspace 5'';
          "${mod}+Shift+6" = ''move container to workspace 6'';
          "${mod}+Shift+7" = ''move container to workspace 7'';
          "${mod}+Shift+8" = ''move container to workspace 8'';
          "${mod}+Shift+9" = ''move container to workspace 9'';
          "${mod}+Shift+0" = ''move container to workspace 10'';

          # fn keys
          "${mod}+F1" = ''restart'';
          "${mod}+F10" = ''exec --no-startup-id ${pkgs.grim}/bin/grim   ''$XDG_PICTURES_DIR/''$(date +'%H:%M:%S.png')'';
          "${mod}+Shift+F10" = ''exec --no-startup-id ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" ''$XDG_PICTURES_DIR/''$(date +'%H:%M:%S.png')'';
          "${mod}+F11" = ''exec --no-startup-id rofi-bluetooth'';

          # other keys
          "${mod}+Return" = ''exec ${pkgs.dunst}/bin/dunstify "Use slash or semicolon punk "'';
          "${mod}+Space" = ''exec --no-startup-id ${term} -e ${pkgs.lf}/bin/lf'';
          # "${mod}+Escape" = ''exec --no-startup-id ${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 200 --indicator-thickness 10 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 6272a4 --key-hl-color ff79c6 --line-color 6272a400 --inside-color 282a3688 --separator-color 282a3600 --fade-in 0.2 --font 'Iosevka Comfy' --font-size 32 --timestr '%I:%M:%S' --datestr '%e %B %Y' --text-color f8f8f2'';
          "${mod}+Escape" = ''exec --no-startup-id rofi-powermenu'';
          "${mod}+Tab" = ''layout toggle tabbed split'';
          "${mod}+grave" = ''workspace back_and_forth'';
          "${mod}+apostrophe" = ''split horizontal ;; exec --no-startup-id ${term}'';
          "${mod}+slash" = ''split vertical ;; exec --no-startup-id ${term}'';
          "${mod}+Shift+slash" = ''kill'';

          # XF Keys
          "XF86PowerOff" = ''exec --no-startup-id rofi-powermenu'';
          "XF86AudioRaiseVolume" = ''exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%'';
          "XF86AudioLowerVolume" = ''exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%'';
          "XF86AudioMute" = ''exec --no-startup-id bin/pactl set-sink-mute @DEFAULT_SINK@ toggle'';
          "XF86MonBrightnessDown" = ''exec ${pkgs.light}/bin/light -U 10'';
          "XF86MonBrightnessUp" = ''exec ${pkgs.light}/bin/light -A 10'';
          "XF86HomePage" = ''exec ${pkgs.dunst}/bin/dunstify "Home Button"'';

          # Arrow Keys
          "${mod}+Left" = ''focus left'';
          "${mod}+Shift+Left" = ''resize shrink width 5 px or 5 ppt'';
          "${mod}+Ctrl+Left" = ''move workspace to output right'';
          "${mod}+Down" = ''focus down'';
          "${mod}+Shift+Down" = ''resize shrink height 5 px or 5 ppt'';
          "${mod}+Ctrl+Down" = ''move workspace to output up'';
          "${mod}+Up" = ''focus up'';
          "${mod}+Shift+Up" = ''resize grow height 5 px or 5 ppt'';
          "${mod}+Ctrl+Up" = ''move workspace to output down'';
          "${mod}+Right" = ''focus right'';
          "${mod}+Shift+Right" = ''resize grow width 5 px or 5 ppt'';
          "${mod}+Ctrl+Right" = ''move workspace to output left'';
        };
        keycodebindings = {
          # The prt screen button
          "107" = ''exec --no-startup-id ${pkgs.grim}/bin/grim   ''$XDG_PICTURES_DIR/''$(date +'%H:%M:%S.png')'';
        };
      };
      extraConfig = ''
        # swayfx config
        corner_radius 12
        for_window [class="^.*"] border pixel 2
        for_window [floating] border pixel 2

        # TODO: Add https://github.com/ldelossa/sway-fzfify for this

        # Stylix.nix has alternative definitions which are worse I think
        # class                 border  bground text    indicator child_border
        client.focused          #50fa7b #6272A4 #F8F8F2 #62d6e8   #62d6e8
        client.focused_inactive #44475A #44475A #F8F8F2 #44475A   #44475A
        client.unfocused        #282A36 #282A36 #BFBFBF #282A36   #282A36
        client.urgent           #44475A #FF5555 #F8F8F2 #FF5555   #FF5555
        client.placeholder      #282A36 #282A36 #F8F8F2 #282A36   #282A36

        client.background       #50fa7b
        #client.background       #F8F8F2
      '';
    };
  };
}
