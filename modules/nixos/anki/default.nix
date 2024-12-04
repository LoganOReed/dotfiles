{
  pkgs,
  lib,
  config,
  sops,
  ...
}:
with lib; let
  cfg = config.modules.anki;
in {
  options.modules.anki = {enable = mkEnableOption "anki";};
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      anki-bin
      texlive.combined.scheme-full
    ];
  };
}
