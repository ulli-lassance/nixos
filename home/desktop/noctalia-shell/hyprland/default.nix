{ pkgs, ... }:

{
  stylix.targets = {
    hyprland.enable = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # Set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
  };

  imports = [
    ./hyprland.nix
  ];

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

    ".config/hypr/xdph.conf".text = ''
      screencopy {
          allow_token_by_default = true
      }
    '';
  };
}
