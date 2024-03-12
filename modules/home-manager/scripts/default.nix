{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.scripts;
    #screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
    #bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
    bashmount = pkgs.writeShellScriptBin "bashmount" ''${builtins.readFile ./bashmount}'';
    ufetch = pkgs.writeShellScriptBin "ufetch" ''${builtins.readFile ./ufetch}'';

in {
    options.modules.scripts = { enable = mkEnableOption "scripts"; };
    config = mkIf cfg.enable {
    	home.packages = with pkgs; [
            ripgrep ffmpeg tealdeer
            eza htop fzf
            pass gnupg bat
            unzip lowdown zk
            grim slurp slop
            imagemagick age libnotify
            git python3 lua zig 
            mpv firefox pqiv procps
            #screen bandw maintenance
            bashmount rxfetch ufetch
        ];
    };
}
