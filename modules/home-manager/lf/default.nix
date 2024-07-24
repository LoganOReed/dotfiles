{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.lf;
in {
  options.modules.lf = {enable = mkEnableOption "lf";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bat
      eza
    ];

    xdg.configFile."lf/icons".source = ./icons;

    programs.lf = {
      enable = true;
      commands = {
        z = ''
          %{{
            result="$(zoxide query --exclude $PWD "$@")"
            lf -remote "send $id cd '$result'"
          }}
        '';
        zi = ''
          ''${{
            result="$(${pkgs.zoxide}/bin/zoxide query -i)"
            lf -remote "send $id cd '$result'"
          }}
        '';
        editor-open = ''$$EDITOR $f'';
        mkdir = ''
          ''${{
            printf "Directory Name: "
            read DIR
            mkdir $DIR
          }}
        '';
        mkfile = ''
          %{{
            printf " "
            read DIR
            touch $DIR
          }}
        '';
        on-cd = ''
          &{{
                  zoxide add "$PWD"
          }}
        '';

        on-select = ''
          &{{
              lf -remote "send $id set statfmt \"$(${pkgs.eza} -ld --color=always "$f")\""
          }}
        '';
      };

      keybindings = {
        "\\\"" = "";
        f = "zi";
        i = "mkfile";
        o = "mkdir";
        D = "delete";
        "." = "set hidden!";
        "`" = "mark-load";
        "\\'" = "mark-load";
        "<enter>" = "open";
        "<esc>" = "clear";

        "g~" = "cd";
        gh = "cd";

        ee = "editor-open";
        V = ''
          ''${{
            ${pkgs.bat}/bin/bat --theme=Dracula --paging=always "$f"
          }}
        '';

        # ...
      };

      settings = {
        preview = true;
        hidden = false;
        drawbox = true;
        icons = true;
        ignorecase = true;
      };

      extraConfig = let
        previewer = pkgs.writeShellScriptBin "pv.sh" ''
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5

          if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
              ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
              exit 1
          fi

          ${pkgs.pistol}/bin/pistol "$file"
        '';
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh

        map r
        map c :rename; cmd-delete-home
        map C :rename; cmd-end; cmd-delete-home

      '';
    };
  };
}
