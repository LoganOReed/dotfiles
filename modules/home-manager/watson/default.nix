{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.watson;
in {
  options.modules.watson = {enable = mkEnableOption "watson";};
  config = mkIf cfg.enable {
    programs.watson = {
      enable = true;
      package = inputs.watson-personal.packages."x86_64-linux".watson;
      enableZshIntegration = false;

      settings = {
        backend = {
          repo = "git@github.com:LoganOReed/watson-data";
        };

        default_tags = {
          wildflower = "TandemCo";
          txjhs = "TandemCo";
          dacamera = "TandemCo";
        };

        options = {
          stop_on_start = true;
          stop_on_restart = false;
          date_format = "%Y.%m.%d";
          time_format = "%H:%M:%S%z";
          week_start = "monday";
          log_current = false;
          pager = true;
          report_current = false;
          reverse_log = true;
        };
      };
    };

    home.file.".zsh/completion/watson/watson.zsh-completion".source = ./watson.zsh-completion;
    # Add completion to zsh
    programs.zsh = {
      initExtra = ''
        fpath=( "/home/occam/.zsh/completion/watson" "''${fpath[@]}" )
        source "/home/occam/.zsh/completion/watson/watson.zsh-completion"
        compdef _watson_completion watson
        export WATSON_DIR="''$HOME/.config/watson"
      '';
    };
  };
}
