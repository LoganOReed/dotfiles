{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.modules.bitwarden;

in {
    options.modules.bitwarden = { enable = mkEnableOption "bitwarden"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    bitwarden-cli
	];
        # Add completion to zsh
        programs.zsh = {
            initExtra = ''
              #Setup bitwarden
              eval "$(bw completion --shell zsh); compdef _bw bw;"
              bw config server https://vault.loganreed.org
              bw login --apikey
            '';
        };
    };
}
