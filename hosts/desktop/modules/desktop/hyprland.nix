{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = false;
  };

  security.pam.services.hyprlock = { };
}
