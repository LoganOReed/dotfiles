{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  security.pam.services = {
    swaylock.u2fAuth = true;
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

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
      ]);
    };
  };
}
