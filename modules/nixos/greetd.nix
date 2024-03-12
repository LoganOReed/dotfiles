# FROM: https://drakerossman.com/blog/wayland-on-nixos-confusion-conquest-triumph

{
  pkgs,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = rec {
     initial_session = {
       user = "occam";
       command = ''
      ${pkgs.greetd.tuigreet}/bin/tuigreet \
        --time \
        --asterisks \
        --user-menu \
        --cmd Hyprland
    '';};
    sway_session = {
       user = "occam";
       command = ''
      ${pkgs.greetd.tuigreet}/bin/tuigreet \
        --time \
        --asterisks \
        --user-menu \
        --cmd sway
    '';};
    default_session = initial_session;
    };
  };

  environment.etc."greetd/environments".text = ''
    hyprland
  '';
}
