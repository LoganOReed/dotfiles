{pkgs, ...}: {
  # Install fonts
  fonts = {
    packages = with pkgs; [
      monolisa
      iosevka-comfy.comfy
      iosevka-comfy.comfy-motion
      noto-fonts-color-emoji
      font-awesome
      powerline-symbols
      openmoji-color
      nerd-fonts.iosevka
    ];
  };
}
