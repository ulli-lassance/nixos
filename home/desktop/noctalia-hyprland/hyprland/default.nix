{ pkgs, ... }:

{
  stylix.targets = {
    hyprland.enable = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Use the NixOS system module to intall Hyprland

    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
  };

  imports = [
    ./portals.nix
    ./hyprland.nix
  ];

  services = {
    hyprpaper.enable = true;
    polkit-gnome.enable = true;
  };

  home.packages = with pkgs; [
    hyprshot
    # Script dependencies
    jq
  ];

  home.file = {
    ".config/hypr/scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };
}
