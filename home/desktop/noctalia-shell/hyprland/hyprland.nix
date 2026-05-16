{ config, lib, ... }:

{
  imports = [
    ./binds.nix
    ./rules.nix
    ./env.nix
  ];

  wayland.windowManager.hyprland = {
    settings = with config.lib.stylix.colors; {

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;

          col = {
            active_border = "rgba(${base0D}ff)";
            inactive_border = "rgba(${base03}ff)";
          };

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
            color = lib.generators.mkLuaInline "0xff${base00}";
          };
        };

        animations = {
          enabled = true;
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

      monitor = {
        output = "DP-1";
        mode = "2560x1440@180";
        position = "0x0";
        scale = "1";
      };

      workspace = [
        { name = "1"; persistent = true; }
        { name = "2"; persistent = true; }
        { name = "3"; persistent = true; }
        { name = "4"; persistent = true; }
        { name = "5"; persistent = true; }
      ];

      curve = [
        {
          _args = [
            "easeOutExpo"
            (lib.generators.mkLuaInline "{ type = \"bezier\", points = { {0.16, 1}, {0.3, 1} } }")
          ];
        }
        {
          _args = [
            "easeOutQuad"
            (lib.generators.mkLuaInline "{ type = \"bezier\", points = { {0.5, 1}, {0.89, 1} } }")
          ];
        }
        {
          _args = [
            "criticallyDamped"
            (lib.generators.mkLuaInline "{ type = \"bezier\", points = { {0.1, 1}, {0.1, 1} } }")
          ];
        }
      ];

      animation = [
        { leaf = "windowsIn"; enabled = true; speed = 2.0; bezier = "easeOutExpo"; style = "slide"; }
        { leaf = "windowsOut"; enabled = true; speed = 2.0; bezier = "easeOutQuad"; style = "slide"; }
        { leaf = "windowsMove"; enabled = true; speed = 2.5; bezier = "criticallyDamped"; style = "slide"; }
        { leaf = "fade"; enabled = true; speed = 2.0; bezier = "easeOutQuad"; }
        { leaf = "workspaces"; enabled = true; speed = 2.5; bezier = "criticallyDamped"; style = "slidevert"; }
        { leaf = "specialWorkspace"; enabled = true; speed = 2.5; bezier = "criticallyDamped"; style = "slidevert"; }
        { leaf = "layers"; enabled = true; speed = 2.5; bezier = "criticallyDamped"; style = "slidevert"; }
      ];
    };

    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("noctalia-shell")
        hl.exec_cmd("bash -c 'for i in {1..5}; do hyprctl dispatch workspace $i; done; hyprctl dispatch workspace 1'")
      end)
    '';
  };
}
