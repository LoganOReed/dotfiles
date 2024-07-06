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
              bw config server $(cat ${config.sops.secrets."bitwarden/url".path})
              export BW_CLIENTID="$(cat ${config.sops.secrets."bitwarden/api/client_id".path})"
              export BW_CLIENTSECRET="$(cat ${config.sops.secrets."bitwarden/api/client_secret".path})"
              bw login --apikey
            '';
        };
    };
}
