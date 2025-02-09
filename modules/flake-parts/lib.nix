#TODO: Check if this is now included anywhere, then add it to modules
{
  lib,
  config,
  ...
}: let
  defaultEnable = name: (lib.mkEnableOption name // {default = true;});
in {
  config = {
    flake = {
      myLib = {
        mkEnableOptionDefault = defaultEnable;
      };
    };
  };
}
