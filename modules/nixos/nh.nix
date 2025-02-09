{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nix-inspect # ranger like way of looking at attrs of flakes
    manix
  ];

  # nix-helper
  # nh os switch
  programs.nh = {
    enable = true;
  };
}
