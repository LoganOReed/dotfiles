{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  environment.systemPackages = with pkgs; [
    Dracula-cursors
  ];
  # Stylix Config
  stylix.image = self + /pics/RainbowDracula.png;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

  stylix.fonts = {
    serif = {
      package = pkgs.iosevka-comfy.comfy-motion;
      name = "Iosevka Comfy Serif";
      # package = pkgs.monolisa;
      # name = "MonoLisa Nerd Font";
    };

    sansSerif = {
      package = pkgs.iosevka-comfy.comfy;
      name = "Iosevka Comfy Sans";
      # package = pkgs.monolisa;
      # name = "MonoLisa Nerd Font";
    };

    monospace = {
      # package = pkgs.iosevka-comfy.comfy;
      # name = "Iosevka Comfy Sans";
      package = pkgs.monolisa;
      name = "MonoLisa Nerd Font";
    };

    emoji = {
      # package = pkgs.noto-fonts-color-emoji;
      # name = "Noto Color Emoji";
      package = pkgs.monolisa;
      name = "MonoLisa Nerd Font";
    };
  };

  stylix.fonts.sizes = {
    applications = 12;
    terminal = 16;
    desktop = 12;
    popups = 12;
  };

  stylix.cursor.package = pkgs.Dracula-cursors;
  stylix.cursor.name = "Dracula-cursors";
  stylix.cursor.size = 16;

  stylix.polarity = "dark";
}
