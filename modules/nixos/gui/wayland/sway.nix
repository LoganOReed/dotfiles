{
  flake,
  pkgs,
  config,
  ...
}:
let
  inherit (flake.config) me;
in
{
  environment.systemPackages = with pkgs; [
    vim-sway-nav
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "${me.username}";
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd sway
        '';
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
  '';

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };
}
