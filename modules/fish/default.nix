{ config, pkgs, ... }:

{
  programs.fish.enable = true;

  stylix.targets.fish.enable = true;

  home.file = {
    ".config/fish/conf.d/user_config.fish".source = ./config.fish;

    ".config/fish/scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };
}