{ pkgs, ... }:

{
  home.packages = with pkgs; [
    heroic
    # prismlauncher

    deadlock-mod-manager

    fflogs
    xivlauncher
  ];

}
