{ pkgs, ... }:

{
  services.network-manager-applet = {
    enable = true;
    package = pkgs.networkmanagerapplet;
  };
}
