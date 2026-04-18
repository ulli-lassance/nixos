{ pkgs, ... }:

{
  home.packages = with pkgs; [
    heroic
    prismlauncher
    
    fflogs
    xivlauncher-rb
  ];

}
