# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  anki = import ./anki;
  wireguard = import ./wireguard;
  music = import ./music;
  homeserver = import ./homeserver;
  ssh = import ./ssh;
  sshfs = import ./sshfs;
  syncthing = import ./syncthing;
}
