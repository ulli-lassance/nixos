{ pkgs, ... }:

{
  xdg.configFile = {
    "niri" = {
      source = ./config;
      recursive = true;
    };
  };
}
