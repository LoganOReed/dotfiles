{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.dunst;
in {
  options.modules.dunst = {enable = mkEnableOption "dunst";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dunst
    ];

    services.dunst = {
      enable = true;
      # settings = {
      #     global = {
      #         origin = "top-right";
      #         offset = "60x12";
      #         separator_height = 2;
      #         padding = 12;
      #         horizontal_padding = 12;
      #         text_icon_padding = 12;
      #         frame_width = 4;
      #         separator_color = "frame";
      #         idle_threshold = 120;
      #         font = "Iosevka Comfy 12";
      #         line_height = 0;
      #         format = "<b>%s</b>\n%b";
      #         alignment = "center";
      #         icon_position = "off";
      #         startup_notification = "false";
      #         corner_radius = 12;
      #
      #         frame_color = "#${base0A}";
      #         background = "#${base00}";
      #         foreground = "#${base05}";
      #         timeout = 2;
      #     };
      # };
    };
  };
}
