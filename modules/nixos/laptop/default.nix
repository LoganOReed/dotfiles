{pkgs, ...}: {
  imports = [
    ./battery.nix
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  # Let wm access monitor light
  programs.light.enable = true;


  environment.systemPackages = with pkgs; [
    # pulseaudio
  ];

  #TODO: add closing lid support

}
