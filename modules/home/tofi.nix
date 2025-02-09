{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.tofi;
in {
  options.my.tofi = {enable = mkEnableOption "tofi";};
  config = mkIf cfg.enable {
    programs.tofi = {
      enable = true;
      # settings."prompt-text" = lib.mkForce " ";
      settings = with config.lib.stylix.colors; {
        # general
        prompt-text = lib.mkForce " ";
        hide-cursor = lib.mkForce "false";
        history = lib.mkForce "true";

        # font
        font-size = lib.mkForce "32";
        # style
        border-width = lib.mkForce "0";
        outline-width = lib.mkForce "0";
        height = lib.mkForce "100%";
        width = lib.mkForce "100%";
        padding-left = lib.mkForce "35%";
        padding-top = lib.mkForce "17%";
        prompt-padding = lib.mkForce "20";
        result-spacing = lib.mkForce "5";

        # colors
        placeholder-color = lib.mkForce "#${base02}";
        background-color = lib.mkForce "#${base00}";
        border-color = lib.mkForce "#${base00}";
        selection-color = lib.mkForce "#${base0A}";
        text-color = lib.mkForce "#${base05}";
        prompt-color = lib.mkForce "#${base08}";
      };
    };
    #       home.file.".config/tofi/config".text = with config.stylix.base16Scheme; ''
    # general
    # prompt-text = " "
    # hide-cursor = false
    # history     = true
    #
    # # font
    # font = Iosevka Comfy
    # font-size=32
    # # style
    # border-width = 0
    # outline-width = 0
    # height = 100%
    # width = 100%
    # padding-left = 35%
    # padding-top = 17%
    # prompt-padding = 20
    # result-spacing = 5
    # # colors
    #
    # placeholder-color = #${base02}
    # background-color = #${base00}
    # border-color = #${base00}
    # outline-color= #000000
    # selection-color = #${base0A}
    # text-color = #${base05}
    # prompt-color = #${base08}
    #       '';
  };
}
