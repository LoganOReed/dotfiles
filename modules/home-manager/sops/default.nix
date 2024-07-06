{ pkgs, lib, config, sops, ... }:

with lib;
let 
  cfg = config.modules.sops;

in {
    options.modules.sops = { enable = mkEnableOption "sops"; };
    config = mkIf cfg.enable {
      sops = {
        age.keyFile = "/home/occam/.config/sops/age/keys.txt"; # must have no password!
        # It's also possible to use a ssh key, but only when it has no password:
        #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
        defaultSopsFile = ../../../secrets/secrets.yaml;
        # secrets.test = {
          # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

          # %r gets replaced with a runtime directory, use %% to specify a '%'
          # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
          # DARWIN_USER_TEMP_DIR) on darwin.
          # path = "%r/test.txt"; 
        # };
      };
    };
}
