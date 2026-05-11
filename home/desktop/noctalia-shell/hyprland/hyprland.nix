{ config, ... }:

{
  imports = [
    ./binds.nix
    ./rules.nix
    ./env.nix
  ];

  wayland.windowManager.hyprland = {
    settings = with config.lib.stylix.colors; {

      monitor = "DP-1, 2560x1440@180, 0x0, 1";

      workspace = [
        "1, persistent:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
        "5, persistent:true"
      ];

      exec-once = [
        "noctalia-shell"
        "bash -c 'for i in {1..5}; do hyprctl dispatch workspace $i; done; hyprctl dispatch workspace 1'"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;

        "col.active_border" = "0xff${base0D}";
        "col.inactive_border" = "0xff${base03}";

        resize_on_border = false;
        allow_tearing = true;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        active_opacity = 0.95;
        inactive_opacity = 0.95;

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "0xff${base00}";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "easeOutQuad, 0.5, 1, 0.89, 1"

          "criticallyDamped, 0.1, 1, 0.1, 1"
        ];

        animation = [
          "windowsIn, 1, 2.0, easeOutExpo, slide"
          
          "windowsOut, 1, 2.0, easeOutQuad, slide"
          
          "windowsMove, 1, 2.5, criticallyDamped, slide"
          
          "fade, 1, 2.0, easeOutQuad"
          
          "workspaces, 1, 2.5, criticallyDamped, slidevert"
          "specialWorkspace, 1, 2.5, criticallyDamped, slidevert"
          "layers, 1, 2.5, criticallyDamped, slidevert"
        ];
      };

      dwindle = {
        preserve_split = true;
      };

      scrolling = {
        fullscreen_on_one_column = false;
        column_width = 0.5;
        direction = "right";
        explicit_column_widths = "0.5, 0.667, 1.0";
        follow_min_visible = 1;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 0;
      };

      input = {
        kb_layout = "us,br";
        kb_options = "caps:escape";

        follow_mouse = 1;
        force_no_accel = 1;
        sensitivity = 0;
      };
    };
  };
}
