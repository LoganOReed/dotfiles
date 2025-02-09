{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.waybar;
in {
  options.my.waybar = {enable = mkEnableOption "waybar";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl
      pavucontrol
      calcurse
    ];

    services.mpdris2 = {
      enable = true;
      multimediaKeys = true;
      notifications = true;
    };

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = ["sway/workspaces" "tray" "sway/mode"];
          modules-center = ["mpris"];
          modules-right = ["network" "battery" "clock"];

          "sway/workspaces" = {
            disable-scroll = true;
            # only show workspaces on their respective monitors
            all-outputs = false;
            format = "{icon} {name}";
            format-icons = {
              "1" = " ";
              "2" = " ";
              "3" = " ";
              # "4" = " ";
              # "5" = " ";
              "7" = " ";
              "8" = "󰊫 ";
              "9" = " ";
              "0" = " ";
              urgent = " ";
              # focused = "";
              # default = " ";
              default = " ";
            };
          };

          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };

          "disk#ssd" = {
            interval = 30;
            format = "{path} {free}";
            path = "/";
            tooltip = true;
            warning = 75;
            critical = 90;
          };

          "network" = {
            #interface = "enp1s0"; # (Optional) To force the use of this interface
            format-wifi = "{essid}  ";
            # format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
            format-ethernet = "";
            format-linked = "(No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            on-click = "nm-connection-editor";
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          "clock" = {
            timezone = "America/New_York";
            format = "{:%I:%M} 󰃭 ";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            on-click = "kitty ${pkgs.calcurse}/bin/calcurse";
          };

          "battery" = {
            states = {
              # good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon} ";
            format-charging = "{capacity}%  ";
            format-plugged = "{capacity}%  ";
            format-alt = "{time} {icon} ";
            format-icons = ["" "" "" "" ""];
          };

          "pulseaudio" = {
            scroll-step = 5; # %, can be a float
            # format = "{volume}% {icon} {format_source}";
            format = "{volume}% {icon} ";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              # "default": ["", "", ""]
            };
            on-click = "rofi-bluetooth &";
            on-click-right = "pavucontrol";
          };
          "custom/playerctl#backward" = {
            format = "󰙣 ";
            on-click = "playerctl previous";
            on-scroll-up = "playerctl volume .05+";
            on-scroll-down = "playerctl volume .05-";
          };
          "custom/playerctl#play" = {
            format = "{icon}";
            return-type = "json";
            exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
            on-click = "playerctl play-pause";
            on-scroll-up = "playerctl volume .05+";
            on-scroll-down = "playerctl volume .05-";
            format-icons = {
              Playing = "<span>󰏥 </span>";
              Paused = "<span> </span>";
              Stopped = "<span> </span>";
            };
          };
          "custom/playerctl#forward" = {
            format = "󰙡 ";
            on-click = "playerctl next";
            on-scroll-up = "playerctl volume .05+";
            on-scroll-down = "playerctl volume .05-";
          };
          "custom/playerlabel" = {
            format = "<span>󰎈 {} 󰎈</span>";
            return-type = "json";
            max-length = 60;
            exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}'";
            on-click = "playerctl play-pause";
            on-click-right = "kitty --class ncmpcpp ncmpcpp";
          };
          "mpris" = {
            # format = "DEFAULT: {player_icon} {dynamic}";
            format = "─┤░ {title} ░├─";
            # format-paused = "{status_icon} <i>{dynamic}</i>";
            format-paused = "─┤░ {title} ░├─";
            on-click-middle = "playerctl pause";
            on-click-right = "playerctl volume 0.0";

# ░█
            player-icons = {
              default = "▶";
              mpv = "🎵";
            };
            status-icons = {
              paused = "⏸";
            };
          };
        };
      };

      style = ''
        #custom-playerctl.backward {
            color: #cba6f7;
            border-radius: 24px 0px 0px 10px;
            padding-left: 16px;
            margin-left: 7px;
        }
        #custom-playerctl.play {
            color: #89b4fa;
            padding: 0 5px;
        }
        #custom-playerctl.foward {
            color: #f5f5f5;
            border-radius: 0px 10px 24px 0px;
            padding-right: 12px;
            margin-right: 7px
        }
      '';

      #           style = with config.lib.stylix.colors;''
      # * {
      #     all: unset;
      #     border: none;
      #     border-radius: 4;
      #     font-family: Iosevka Comfy Mono;
      #     font-size: 13px;
      #     min-height: 0;
      # }
      #
      # window#waybar {
      #     background: @theme_base_color;
      #     background-color: rgba(43, 48, 59, 0.9);
      #     border-bottom: 3px solid rgba(100, 114, 125, 0.5);
      #     color: #${base06};
      #     transition-property: background-color;
      #     transition-duration: .5s;
      #     border-radius: 0;
      # }
      #
      # window#waybar.hidden {
      #     opacity: 0.2;
      # }
      #
      # tooltip {
      #   background: rgba(43, 48, 59, 0.5);
      #   border: 1px solid rgba(100, 114, 125, 0.5);
      # }
      #
      # tooltip label {
      #   color: @theme_text_color;
      # }
      #
      # /*
      # window#waybar.empty {
      #     background-color: transparent;
      # }
      # window#waybar.solo {
      #     background-color: #FFFFFF;
      # }
      # */
      #
      # #workspaces button {
      #     padding: 0 0.7em;
      #     background-color: transparent;
      #     color: #f8f8f2;
      #     box-shadow: inset 0 -3px transparent;
      # }
      #
      # #workspaces button:hover {
      #     background: rgba(0, 0, 0, 0.2);
      #     box-shadow: inset 0 -3px #ffffff;
      # }
      #
      # #workspaces button.focused {
      #     background-color: #64727D;
      #     box-shadow: inset 0 -3px #f8f8f2;
      # }
      #
      # #workspaces button.urgent {
      #     background-color: #eb4d4b;
      # }
      #
      # #mode {
      #     background-color: #64727D;
      #     border-bottom: 3px solid #ffffff;
      # }
      #
      # #clock,
      # #battery,
      # #cpu,
      # #memory,
      # #disk,
      # #temperature,
      # #backlight,
      # #network,
      # #pulseaudio,
      # #custom-weather,
      # #tray,
      # #mode,
      # #idle_inhibitor,
      # #custom-notification,
      # #sway-scratchpad,
      # #mpd {
      #     padding: 0 10px;
      #     margin: 6px 3px;
      #     color: #f8f8f2;
      # }
      #
      # #window,
      # #workspaces {
      #     margin: 0 4px;
      # }
      #
      # /* If workspaces is the leftmost module, omit left margin */
      # .modules-left > widget:first-child > #workspaces {
      #     margin-left: 0;
      # }
      #
      # /* If workspaces is the rightmost module, omit right margin */
      # .modules-right > widget:last-child > #workspaces {
      #     margin-right: 0;
      # }
      #
      # #clock {
      #     background-color: #${base0B};
      #     color: #282a36;
      # }
      #
      # #battery {
      #     background-color: #${base0C};
      #     color: #282a36;
      # }
      #
      # #battery.charging, #battery.plugged {
      #     color: #282a36;
      #     background-color: #${base0C};
      # }
      #
      # @keyframes blink {
      #     to {
      #         background-color: #ffffff;
      #         color: #000000;
      #     }
      # }
      #
      # #battery.critical:not(.charging) {
      #     background-color: #f53c3c;
      #     color: #ffffff;
      #     animation-name: blink;
      #     animation-duration: 0.5s;
      #     animation-timing-function: linear;
      #     animation-iteration-count: infinite;
      #     animation-direction: alternate;
      # }
      #
      # label:focus {
      #     background-color: #000000;
      # }
      #
      # #cpu {
      #     background-color: #${base0B};
      #     color: #282a36;
      # }
      #
      # #memory {
      #     background-color: #${base0B};
      #     color: #282a36;
      # }
      #
      # #backlight {
      #     background-color: #90b1b1;
      # }
      #
      # #network {
      #     background-color: #${base0A};
      #     color: #282a36;
      # }
      #
      # #network.disconnected {
      #     background-color: #ffa000;
      #     color: #282a36;
      # }
      #
      # #pulseaudio {
      #     background-color: #bd93f9;
      #     color: #282a36;
      # }
      #
      # #pulseaudio.muted {
      #     background-color: #44475a;
      #     color: #f8f8f2;
      # }
      #
      # #custom-media.custom-spotify {
      #     background-color: #66cc99;
      # }
      #
      # #custom-media.custom-vlc {
      #     background-color: #ffa000;
      # }
      #
      # #temperature {
      #     background-color: #ff79c6;
      #     color: #282a36;
      # }
      #
      # #temperature.critical {
      #     background-color: #ff5555;
      #     color: #282a36;
      # }
      #
      # #tray {
      #     background-color: #bd93f9
      # }
      #
      # #tray > .passive {
      #     -gtk-icon-effect: dim;
      # }
      #
      # #tray > .needs-attention {
      #     -gtk-icon-effect: highlight;
      #     background-color: #eb4d4b;
      # }
      #
      # #idle_inhibitor {
      #     background-color: #44475a;
      #     color: #f8f8f2;
      # }
      #
      # #idle_inhibitor.activated {
      #     background-color: #f8f8f2;
      #     color: #44475a;
      # }
      #
      # #mpd {
      #     background-color: #66cc99;
      #     color: #2a5c45;
      # }
      #
      # #mpd.disconnected {
      #     background-color: #f53c3c;
      # }
      #
      # #mpd.stopped {
      #     background-color: #90b1b1;
      # }
      #
      # #mpd.paused {
      #     background-color: #51a37a;
      # }
      #
      # #language {
      #     background-color: #f8f8f2;
      #     color: #282a36;
      #     padding: 0 5px;
      #     margin: 6px 3px;
      #     min-width: 16px;
      # }
      #
      # #keyboard-state {
      #     background-color: #97e1ad;
      #     color: #000000;
      #     padding: 0 0px;
      #     margin: 0 5px;
      #     min-width: 16px;
      # }
      #
      # #keyboard-state > label {
      #     padding: 0 5px;
      # }
      #
      # #keyboard-state > label.locked {
      #     background: rgba(0, 0, 0, 0.2);
      # }
      #
      # #custom-weather {
      #     background-color: #${base0C};
      #     color: #282a36;
      #     margin-right: 5;
      # }
      #
      # #disk {
      #     background-color: #ffb86c;
      #     color: #282a36;
      # }
      #
      # #sway-scratchpad {
      #     background-color: #${base0A};
      #     color: #282a36;
      # }
      #           '';
    };
  };
}
# scheme: "Dracula"
# author: "Mike Barkmin (http://github.com/mikebarkmin) based on Dracula Theme (http://github.com/dracula)"
# base00: "#282936" #background
# base01: "#3a3c4e"
# base02: "#4d4f68"
# base03: "#626483"
# base04: "#62d6e8"
# base05: "#e9e9f4" #foreground
# base06: "#f1f2f8"
# base07: "#f7f7fb"
# base08: "#ea51b2"
# base09: "#b45bcf"
# base0A: "#00f769"
# base0B: "#ebff87"
# base0C: "#a1efe4"
# base0D: "#62d6e8"
# base0E: "#b45bcf"
# base0F: "#00f769"

