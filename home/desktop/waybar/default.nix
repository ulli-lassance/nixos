{ config, pkgs, ... }:

let
  modules = import ./modules.nix;
in
{
  stylix.targets.waybar.enable = false;

  home.packages = with pkgs; [
    pamixer
    playerctl
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style =
      with config.lib.stylix.colors;
      ''
        @define-color background #${base00};
        @define-color bg-select #${base02};
        @define-color text #${base05};
        @define-color border #${base0D};
        @define-color text-select #${base0D};
      ''
      + builtins.readFile ./style.css;

    settings = [
      (
        {
          layer = "bottom";
          position = "top";
          height = 48;

          modules-left = [
            "custom/l_border"
            "clock"
            "custom/r_border"

            "custom/l_border"
            "pulseaudio#output"
            "pulseaudio#input"
            "mpris"
            "custom/r_border"
          ];

          modules-center = [
            "hyprland/workspaces"
          ];

          modules-right = [
            "wlr/taskbar"

            "tray"

            "custom/l_border"
            # "network"
            "hyprland/language"
            "custom/r_border"

            "custom/l_border"
            "cpu"
            "memory#ram"
            # "temperature"
            "custom/r_border"

            #"custom/power"
          ];

        }
        // modules
      )
    ];
  };

}
