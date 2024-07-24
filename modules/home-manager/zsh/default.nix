{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.zsh;
in {
  options.modules.zsh = {enable = mkEnableOption "zsh";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh
      disfetch
      eza
    ];

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        dbus-update-activation-environment WAYLAND_DISPLAY
        bindkey '^ ' autosuggest-accept
        disfetch




          # Customizing FZF
              export FZF_DEFAULT_COMMAND='rg --files --hidden'
              export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
              --height=66%
              --margin=5%,2%,2%,5%
              --layout=reverse-list
              --prompt='::'
              --color=dark
              --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
              --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
              '
          # Get path to something
              export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
              export FZF_CTRL_R_OPTS=$FZF_DEFAULT_OPTS'
              --height=33%
              --layout=reverse
              --border
              --info=inline
              --color=dark
              --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
              --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
              '
          # export FZF_CTRL_T_OPTS='--height 96% --reverse --border --info=inline --preview "tree -C {} | head -200"'
              export FZF_COMPLETION_OPTS='--reverse --border --info=inline --preview "bat --color=always {}"'
          # Use ~~ as the trigger sequence instead of the default **
              export FZF_COMPLETION_TRIGGER=""
              bindkey '^T' fzf-completion
              bindkey '^I' $fzf_default_completion
          # Options to fzf command

          # export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

          # Use fd (https://github.com/sharkdp/fd) instead of the default find
          # command for listing path candidates.
          # - The first argument to the function ($1) is the base path to start traversal
          # - See the source code (completion.{bash,zsh}) for the details.
              _fzf_compgen_path() {
                fd --hidden --follow --exclude ".git" . "$1"
              }

          # Use fd to generate the list for directory completion
              _fzf_compgen_dir() {
                fd --type d --hidden --follow --exclude ".git" . "$1"
              }

          # Advanced customization of fzf options via _fzf_comprun function
          # - The first argument to the function is the name of the command.
          # - You should make sure to pass the rest of the arguments to fzf.
              _fzf_comprun() {
                local command=$1
                shift

                case "$command" in
                  cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
                  export|unset) fzf --preview "eval \'echo \$'{}"         "$@" ;;
                  ssh)          fzf --preview 'dig {}'                   "$@" ;;
                  *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
                esac
              }
      '';

      history = {
        save = 10000;
        size = 10000;
        path = "$HOME/.cache/zsh_history";
      };

      shellAliases = {
        l = "eza --icons";
        la = "eza -a --icons";
        cd = "z";
        deploy = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_DIR";
        n = "nvim";
      };
      plugins = [
        {
          name = "pure";
          src = pkgs.fetchFromGitHub {
            owner = "sindresorhus";
            repo = "pure";
            rev = "v1.23.0";
            sha256 = "sha256-BmQO4xqd/3QnpLUitD2obVxL0UulpboT8jGNEh4ri8k=";
          };
        }
      ];
    };
  };
}
