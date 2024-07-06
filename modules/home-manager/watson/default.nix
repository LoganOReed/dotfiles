{ pkgs, lib, config, ... }:

with lib;
let 
  cfg = config.modules.watson;

in {
    options.modules.watson = { enable = mkEnableOption "watson"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    watson
	];
        home.file.".zsh/completion/watson/watson.zsh-completion".source = ./watson.zsh-completion;
        # Add completion to zsh
        programs.zsh = {
            initExtra = ''
                fpath=( "''$HOME/.zsh/completion/watson" "''${fpath[@]}" )
                export WATSON_DIR="''$HOME/.watson"
            '';
        };
    };
}
