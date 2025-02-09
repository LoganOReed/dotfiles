{
  flake,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.my.anki;
in {
  options.my.anki = {enable = mkEnableOption "anki";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      anki-bin
      texlive.combined.scheme-full
    ];

    # This allows everything to be more or less managed by nixos
    # Really just the repo but whatever
    programs.zsh = {
      initExtra = ''
        export ANKI_BASE="/home/occam/dotfiles/modules/home/anki/Anki2"
      '';
    };
  };

}
