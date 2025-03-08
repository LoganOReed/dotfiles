{flake, config, pkgs, ... }:

let 
  inherit (flake.config) me;
  inherit (flake.inputs) secrets;
  user = "${me.username}"; 
in
{

  environment.systemPackages = with pkgs; [
    nix-inspect # ranger like way of looking at attrs of flakes
    manix
    age 
    age-plugin-yubikey 
    yubikey-personalization 
    yubikey-manager
  ];

  age.identityPaths = [
    "/home/${user}/.ssh/id_ed25519"
    "/etc/ssh/ssh_host_ed25519_key"
    "${secrets}/identities/occam-yubikey.txt"
    "${secrets}/identities/occam-yubikey-backup.txt"
  ];

  # age.secrets."syncthing-cert" = {
  #   symlink = true;
  #   path = "/home/${user}/.config/syncthing/cert.pem";
  #   file =  "${secrets}/felix-syncthing-cert.age";
  #   mode = "600";
  #   owner = "${user}";
  #   group = "users";
  # };
  #
  # age.secrets."syncthing-key" = {
  #   symlink = true;
  #   path = "/home/{$user}/.config/syncthing/key.pem";
  #   file =  "${secrets}/felix-syncthing-key.age";
  #   mode = "600";
  #   owner = "${user}";
  #   group = "users";
  # };
  #


  age.secrets."occam-password" = {
    file = "${secrets}/occam-password.age";
  };

  age.secrets."github-ssh-key" = {
    symlink = false;
    path = "/home/${user}/.ssh/id_github";
    file =  "${secrets}/github-ssh-key.age";
    mode = "600";
    owner = "${user}";
    group = "wheel";
  };


  age.secrets."syncthing-gui-password-razor" = {
    file = "${secrets}/syncthing-gui-password-razor.age";
  };


  # age.secrets."github-signing-key" = {
  #   symlink = false;
  #   path = "/home/${user}/.ssh/pgp_github.key";
  #   file =  "${secrets}/github-signing-key.age";
  #   mode = "600";
  #   owner = "${user}";
  #   group = "wheel";
  # };

}
