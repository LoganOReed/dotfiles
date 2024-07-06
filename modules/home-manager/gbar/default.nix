{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.modules.gbar;
in {
    options.modules.gbar= { enable = mkEnableOption "gbar"; };

    config = mkIf cfg.enable {
	programs.gBar = {
        enable = true;
        config = {
	    LockCommand = "swaylock \
        --screenshots \
        --clock \
        --indicator \
        --indicator-radius 200 \
        --indicator-thickness 10 \
        --effect-blur 7x5 \
        --effect-vignette 0.5:0.5 \
        --ring-color 6272a4 \
        --key-hl-color ff79c6 \
        --line-color 6272a400 \
        --inside-color 282a3688 \
        --separator-color 282a3600 \
        --fade-in 0.2 \
        --font 'Iosevka Comfy' \
        --font-size 32 \
        --timestr '%I:%M:%S' \
        --datestr '%A %e %B %Y' \
        --text-color f8f8f2";
	    ExitCommand = "hyprctl dispatch exit";
	    #SuspendCommand = "Systemctl suspend";


            Location = "T";
            EnableSNI = false;
            SNIIconSize = {
	        "*" = 32;
                Discord = 26;
                OBS = 23;
            };
	    MinDownloadBytes = 0;
	    MaxDownloadBytes = 10485760;
	    MinUploadBytes = 0;
	    MaxUploadBytes = 5242880;
	    #DateTimeStyle = "%A %D - %I:%M:%S %p";
	    DateTimeStyle = "";

	    BatteryFolder = "/sys/class/power_supply/BAT0";
	    NetworkAdapter = "wlp0s20f3";
	    DefaultWorkspaceSymbol = "";
	    UseHyprlandIPC = true;
	    CenterTime = false;
	    TimeSpace = 200;
	    DateTimeLocale = "en_US.utf8";
        };
	};

        home.file.".config/gBar/style.css".text = ''
* {
  all: unset;
  font-family: "Iosevka Comfy, Iosevka Nerd Font, FontAwesome";
}

.popup {
  color: #50fa7b;
}

.bar, tooltip {
  background-color: #282a36;
  border-radius: 16px;
}

.right {
  border-radius: 16px;
}

.time-text {
  font-size: 20px;
  padding-left: 6em;
}

.reboot-button {
  font-size: 28px;
  color: #6272a4;
}

.sleep-button {
  font-size: 28px;
  color: #6272a4;
}

.exit-button {
  font-size: 28px;
  color: #6272a4;
}

.power-button {
  font-size: 28px;
  color: #ff5555;
}

.system-confirm {
  color: #50fa7b;
}

trough {
  border-radius: 3px;
  border-width: 1px;
  border-style: none;
  background-color: #44475a;
  min-width: 4px;
  min-height: 4px;
}

slider {
  border-radius: 0%;
  border-width: 1px;
  border-style: none;
  margin: -9px -9px -9px -9px;
  min-width: 16px;
  min-height: 16px;
  background-color: transparent;
}

highlight {
  border-radius: 3px;
  border-width: 1px;
  border-style: none;
  min-width: 6px;
  min-height: 6px;
}

.audio-icon {
  font-size: 24px;
  color: #ffb86c;
}

.audio-volume {
  font-size: 16px;
  color: #ffb86c;
}
.audio-volume trough {
  background-color: #44475a;
}
.audio-volume slider {
  background-color: transparent;
}
.audio-volume highlight {
  background-color: #ffb86c;
}

.mic-icon {
  font-size: 24px;
  color: #bd93f9;
}

.mic-volume {
  font-size: 16px;
  color: #bd93f9;
}
.mic-volume trough {
  background-color: #44475a;
}
.mic-volume slider {
  background-color: transparent;
}
.mic-volume highlight {
  background-color: #bd93f9;
}

.package-outofdate {
  margin: -5px -5px -5px -5px;
  font-size: 24px;
  color: #ff5555;
}

.bt-num {
  font-size: 16px;
  color: #1793D1;
}

.bt-label-on {
  font-size: 20px;
  color: #1793D1;
}

.bt-label-off {
  font-size: 24px;
  color: #1793D1;
}

.bt-label-connected {
  font-size: 28px;
  color: #1793D1;
}

.disk-util-progress {
  color: #bd93f9;
  background-color: #44475a;
  font-size: 16px;
}

.disk-data-text {
  color: #bd93f9;
  font-size: 16px;
}

.vram-util-progress {
  color: #ffb86c;
  background-color: #44475a;
}

.vram-data-text {
  color: #ffb86c;
  font-size: 16px;
}

.ram-util-progress {
  color: #f1fa8c;
  background-color: #44475a;
}

.ram-data-text {
  color: #f1fa8c;
  font-size: 16px;
}

.gpu-util-progress {
  color: #8be9fd;
  background-color: #44475a;
}

.gpu-data-text {
  color: #8be9fd;
  font-size: 16px;
}

.cpu-util-progress {
  color: #50fa7b;
  background-color: #44475a;
  font-size: 16px;
}

.cpu-data-text {
  color: #50fa7b;
  font-size: 16px;
}

.battery-util-progress {
  color: #ff79c6;
  background-color: #44475a;
  font-size: 16px;
}

.battery-data-text {
  color: #ff79c6;
  font-size: 16px;
}

.network-data-text {
  color: #50fa7b;
  font-size: 16px;
}

.network-up-under {
  color: #44475a;
}

.network-up-low {
  color: #50fa7b;
}

.network-up-mid-low {
  color: #f1fa8c;
}

.network-up-mid-high {
  color: #ffb86c;
}

.network-up-high {
  color: #bd93f9;
}

.network-up-over {
  color: #ff5555;
}

.network-down-under {
  color: #44475a;
}

.network-down-low {
  color: #50fa7b;
}

.network-down-mid-low {
  color: #f1fa8c;
}

.network-down-mid-high {
  color: #ffb86c;
}

.network-down-high {
  color: #bd93f9;
}

.network-down-over {
  color: #ff5555;
}

.ws-dead {
  color: #44475a;
  font-size: 16px;
}

.ws-inactive {
  color: #6272a4;
  font-size: 16px;
}

.ws-visible {
  color: #8be9fd;
  font-size: 16px;
}

.ws-current {
  color: #f1fa8c;
  font-size: 16px;
}

.ws-active {
  color: #50fa7b;
  font-size: 16px;
}

@keyframes connectanim {
  from {
    background-image: radial-gradient(circle farthest-side at center, #1793D1 0%, transparent 0%, transparent 100%);
  }
  to {
    background-image: radial-gradient(circle farthest-side at center, #1793D1 0%, #1793D1 100%, transparent 100%);
  }
}
@keyframes disconnectanim {
  from {
    background-image: radial-gradient(circle farthest-side at center, transparent 0%, #1793D1 0%, #1793D1 100%);
  }
  to {
    background-image: radial-gradient(circle farthest-side at center, transparent 0%, transparent 100%, #1793D1 100%);
  }
}
@keyframes scanonanim {
  from {
    color: #f1fa8c;
  }
  to {
    color: #50fa7b;
  }
}
@keyframes scanoffanim {
  from {
    color: #50fa7b;
  }
  to {
    color: #f1fa8c;
  }
}
.bt-bg {
  background-color: #282a36;
  border-radius: 16px;
}

.bt-header-box {
  margin-top: 4px;
  margin-right: 8px;
  margin-left: 8px;
  font-size: 24px;
  color: #1793D1;
}

.bt-body-box {
  margin-right: 8px;
  margin-left: 8px;
}

.bt-button {
  border-radius: 16px;
  padding-left: 8px;
  padding-right: 8px;
  padding-top: 4px;
  padding-bottom: 4px;
  margin-bottom: 4px;
  margin-top: 4px;
  font-size: 16px;
}
.bt-button.active {
  animation-name: connectanim;
  animation-duration: 50ms;
  animation-timing-function: linear;
  animation-fill-mode: forwards;
}
.bt-button.inactive {
  animation-name: disconnectanim;
  animation-duration: 50ms;
  animation-timing-function: linear;
  animation-fill-mode: forwards;
}
.bt-button.failed {
  color: #ff5555;
}

.bt-close {
  color: #ff5555;
  background-color: #44475a;
  border-radius: 16px;
  padding: 0px 8px 0px 7px;
  margin: 0px 0px 0px 8px;
}

.bt-scan {
  color: #f1fa8c;
  background-color: #44475a;
  border-radius: 16px;
  padding: 2px 11px 0px 7px;
  margin: 0px 0px 0px 10px;
  font-size: 18px;
}
.bt-scan.active {
  animation-name: scanonanim;
  animation-duration: 50ms;
  animation-timing-function: linear;
  animation-fill-mode: forwards;
}
.bt-scan.inactive {
  animation-name: scanoffanim;
  animation-duration: 50ms;
  animation-timing-function: linear;
  animation-fill-mode: forwards;
}
	'';
    };
}
