{pkgs, ...}: {
  services.blueman.enable = true;

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    graphics = {
      enable32Bit = true;
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    pulseaudio
  ];
}
