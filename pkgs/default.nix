# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  Dracula-cursors = 
    pkgs.runCommand "moveUp" {} ''
    mkdir -p $out/share/icons
    ln -s ${pkgs.fetchzip {
      url = "https://github.com/dracula/gtk/releases/download/v4.0.0/Dracula-cursors.tar.xz";
      hash = "sha256-FCjsCGiaDqWisNe7cMgkKv1LLye6OLBOfhtRnkmXsnY=";
    }} $out/share/icons/Dracula-cursors
  '';
}
