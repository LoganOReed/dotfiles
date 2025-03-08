{
  pkgs,
  lib,
  ...
}: {

  environment.systemPackages = with pkgs; [
    yubikey-personalization 
    yubikey-manager
  ];

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.pcscd.enable = true;

  # Yubikey stuff
  security.pam.u2f = {
    enable = true;
    settings = {
      interactive = true;
      cue = true;
      origin = "pam://yubi";
      authfile = pkgs.writeText "u2f-mappings" (lib.concatStrings [
        "occam"
        ":DTudv4m1IOG1f73ackmJtYmiAxyN223GQqHHfn8Oota9+iKE1q8ItmFB3EiyP645hwZwdGrp9Lo3laxIN20nAA==,s8BBGUCEtcspC0uI6u9wgCltpvkqRN/wO1KuAq6gYGlCtigfEoQBrkr9fcXvwZds8QWGcbFzeRkF9LHybqUC4Q==,es256,+presence"
        ":7awGOg95Rie/ttOudO4zePzdkvscJsErkJ5xd52zBp1CPhJZX+ahpjMSxLrS6pwRNVDD/3i/farMaUPYG3wtWQ==,/9DHiQEAqNmb2uaSzvhqyS0R3aEShfkOG5H0t1fw6g89AhngHsCY2kd9yDPuSwb0kKdHBP4JPlKv1/p2XPIqvA==,es256,+presence"
      ]);
    };
  };
}
