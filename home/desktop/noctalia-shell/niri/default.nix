{ pkgs, ... }:

{
  home.file = {
    ".config/niri" = {
      source = ./config;
      recursive = true;
    };
  };
}
