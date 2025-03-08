{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # nix-inspect # ranger like way of looking at attrs of flakes
    # manix
  ];

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["occam"];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
