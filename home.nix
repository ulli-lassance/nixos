{ config, pkgs, ... }:

{
  home.username = "lassance";
  home.homeDirectory = "/home/lassance";
  home.stateVersion = "25.11";
  programs.git = {
    enable = true;
  };  

  imports = [
    ./modules/hyprland/default.nix
    ./modules/waybar/default.nix
    ./modules/rofi/default.nix
    ./modules/dunst/default.nix
    ./modules/kitty/default.nix
    ./modules/fish/default.nix
    ./modules/fastfetch/default.nix

  ];

}