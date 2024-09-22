{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.kdeconnect;
in {
  options.modules.kdeconnect = {enable = mkEnableOption "kdeconnect";};

  config = mkIf cfg.enable {
    # home.packages = with pkgs; [
    # ];

    services.kdeconnect = {
      enable = true;
    };
  };
}
