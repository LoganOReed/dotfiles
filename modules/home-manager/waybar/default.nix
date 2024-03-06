{ pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.waybar;
in {
    options.modules.waybar = { enable = mkEnableOption "waybar"; };

    config = mkIf cfg.enable {
	programs.waybar = {
	  enable = true;
          package = pkgs.waybar.overrideAttrs (oldAttrs: {
            postPatch = ''
              # use hyprctl to switch workspaces
              sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprworkspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
              sed -i 's/gIPC->getSocket1Reply("dispatch workspace " + std::to_string(id()));/const std::string command = "hyprworkspace " + std::to_string(id());\n\tsystem(command.c_str());/g' src/modules/hyprland/workspaces.cpp
            '';
          });
          settings = {
	    mainBar = {
	      layer = "top";
	      position = "top";
	      mode = "dock";
	      exclusive = "true";
	      passthrough = "false";

              modules-left = ["custom/os" "cpu" "memory" "hyprland/workspaces"];
              modules-right = ["backlight" "tray" "clock"];
              modules-center = [];

        "custom/os" = {
          "format" = " {} ";
          "exec" = ''echo "" '';
          "interval" = "once";
        };

        "hyprland/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = " ";
            "2" = " ";
            "3" = " ";
            "4" = " ";
            "5" = " ";
            "6" = " ";
            "7" = " ";
            "8" = " ";
            "9" = " ";
            "scratch_term" = "_";
            "scratch_ranger" = "_󰴉";
            "scratch_musikcube" = "_";
            "scratch_btm" = "_";
            "scratch_geary" = "_";
            "scratch_pavucontrol" = "_󰍰";
          };
          "on-click" = "activate";
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
          #"all-outputs" = true;
          #"active-only" = true;
          "ignore-workspaces" = ["scratch" "-"];
          #"show-special" = false;
          #"persistent-workspaces" = {
          #    # this block doesn't seem to work for whatever reason
          #    "eDP-1" = [1 2 3 4 5 6 7 8 9];
          #    "DP-1" = [1 2 3 4 5 6 7 8 9];
          #    "HDMI-A-1" = [1 2 3 4 5 6 7 8 9];
          #    "1" = ["eDP-1" "DP-1" "HDMI-A-1"];
          #    "2" = ["eDP-1" "DP-1" "HDMI-A-1"];
          #    "3" = ["eDP-1" "DP-1" "HDMI-A-1"];
          #    "4" = ["eDP-1" "DP-1" "HDMI-A-1"];
          #    "5" = ["eDP-1" "DP-1" "HDMI-A-1"];
          #    "6" = ["eDP-1" "DP-1" "HDMI-A-1"];
          #    "7" = ["eDP-1" "DP-1" "HDMI-A-1"];
          #    "8" = ["eDP-1" "DP-1" "HDMI-A-1"];
          #    "9" = ["eDP-1" "DP-1" "HDMI-A-1"];
          #};
        };

    tray = {
        "spacing" = 10;
    };
    clock = {
        "interval" = 1;
        "format" = "{:%H:%M}";
        "format-alt" = "{:%b %d %Y}";
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };

    cpu = {
      "format" = " {}%";
    };
    memory = {
        "format" = " {}%";
        "format-alt" = " {used:0.1f}GB";
        "max-length" = 10;
    };
    
    backlight = {
        "device" = "acpi_video0";
        "format" = "{icon}";
        "tooltip-format" = "{percent}";
        "format-icons" = ["󱩎 " "󱩏 " "󱩐 " "󱩑 " "󱩒 " "󱩓 " "󱩔 " "󱩕 " "󱩖 " "󰛨 "];

              };
	    };
	  };

          style = with config.colorscheme.palette; ''
	  * {
  /* `otf-font-awesome` is required to be installed for icons */
  font-family: FontAwesome, Iosevka Comfy, Material Design Icons, JetBrainsMono Nerd Font, Iosevka Nerd Font;
  font-size: 19px;
  border: none;
  border-radius: 0;
}
window#waybar {
  background-color: rgba(26, 27, 38, 0);
  color: #ffffff;
  transition-property: background-color;
  transition-duration: 0.5s;
}


#window,   
#clock,
#cpu,
#memory,
#custom-media,
#tray,
#mode,
#custom-lock,
#workspaces,
#idle_inhibitor,
#custom-power-menu,
#custom-launcher,
#custom-spotify,
#custom-weather,
#custom-weather.severe,
#custom-weather.sunnyDay,
#custom-weather.clearNight,
#custom-weather.cloudyFoggyDay,
#custom-weather.cloudyFoggyNight,
#custom-weather.rainyDay,
#custom-weather.rainyNight,
#custom-weather.showyIcyDay,
#custom-weather.snowyIcyNight,
#custom-weather.default {
  color: #e5e5e5;
  border-radius: 6px;
  padding: 2px 10px;
  background-color: #252733;
  border-radius: 8px;
  font-size: 18.5px;

  margin-left: 4px;
  margin-right: 4px;

  margin-top: 8.5px;
  margin-bottom: 8.5px;
}

#cpu {
  color: #fb958b;
}

#memory {
  color: #a1c999;
}

#workspaces button {
    padding: 5px;
    color: #313244;
    margin-right: 5px;
}

#workspaces button.active {
    color: #a6adc8;
    background-color: #0F52BA ;
    border-radius: 10px;
}

#workspaces button.focused {
    color: #ff0000;
    background: #ff0000;
    border-radius: 10px;
}

#workspaces button.urgent {
    color: #11111b;
    background: #a6e3a1;
    border-radius: 10px;
}

#workspaces button:hover {
    background: #0F52BA;
    color: #cdd6f4;
    border-radius: 10px;

}
#workspaces {
    background: #252733;
    border-radius: 10px;
    margin-left: 10px;
    padding-right: 0px;
    padding-left: 5px;
	
}

#custom-launcher {
  margin-left: 12px;

  padding-right: 18px;
  padding-left: 14px;

  font-size: 22px;

  color: #7a95c9;

  margin-top: 8.5px;
  margin-bottom: 8.5px;
}

#backlight,
#battery,
#pulseaudio,
#network {
  background-color: #252733;
  padding: 0em 2em;

  font-size: 20px;

  padding-left: 7.5px;
  padding-right: 7.5px;

  padding-top: 3px;
  padding-bottom: 3px;

  margin-top: 7px;
  margin-bottom: 7px;

  font-size: 20px;
}

	  '';
	  };
      };
}



