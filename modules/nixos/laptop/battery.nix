{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    acpi
    tlp
  ];

  # To double check it isn't conflicting with tlp
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
  services.thermald.enable = true;
}
