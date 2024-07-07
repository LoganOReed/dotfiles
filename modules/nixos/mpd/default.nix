{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.modules.mpd;

in {
    options.modules.mpd = { enable = mkEnableOption "mpd"; };
    config = mkIf cfg.enable {

      hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";

      services.mpd = {
        enable = true;
        musicDirectory = "/home/occam/documents/music";
        extraConfig = ''
          # must specify one or more outputs in order to play audio!
          # (e.g. ALSA, PulseAudio, PipeWire), see next sections
          audio_output {
            type "pulse"
            name "My PulseAudio" # this can be whatever you want
            server "127.0.0.1" # add this line - MPD must connect to the local sound server
          }
        '';

        # Optional:
        network.listenAddress = "any"; # if you want to allow non-localhost connections
        startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
      };



    };
}
