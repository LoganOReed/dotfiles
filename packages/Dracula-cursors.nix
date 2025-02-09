{pkgs, ...}:
pkgs.runCommand "Dracula-cursors" {} ''
  mkdir -p $out/share/icons
  ln -s ${pkgs.fetchzip {
    url = "https://github.com/dracula/gtk/releases/download/v4.0.0/Dracula-cursors.tar.xz";
    hash = "sha256-FCjsCGiaDqWisNe7cMgkKv1LLye6OLBOfhtRnkmXsnY=";
  }} $out/share/icons/Dracula-cursors
''
