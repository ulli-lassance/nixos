{ config, pkgs, ... }:

{
  stylix.targets.hyprland.hyprpaper.enable = false;

  home.file = {
    ".config/hypr/keybinds.conf".source = ./keybinds.conf;
    ".config/hypr/rules.conf".source = ./rules.conf;
    ".config/hypr/xdph.conf".source = ./xdph.conf;

    ".config/hypr/scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };

  xdg.configFile."hypr/hyprland.conf".text = with config.lib.stylix.colors; ''
    ################
    ### MONITORS ###
    ################
    monitorv2 {
      output = DP-1
      mode = 2560x1440@180
      position = 0x0
      scale = 1
      vrr = 0
    }


    #################
    ### VARIABLES ###
    #################
    $terminal       = kitty
    $fileManager    = nemo
    $browser        = firefox
    $editor         = codium
    $menu           = pgrep rofi > /dev/null 2>&1 && killall rofi || rofi -show drun
    $powerMenu      = ~/.config/rofi/scripts/toggle-power-menu.sh
    $windowSwitcher = ~/.config/rofi/scripts/toggle-window-switcher.sh

    #################
    ### AUTOSTART ###
    #################
    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = systemctl --user start hyprpolkitagent
    exec-once = dunst
    exec-once = hyprpaper
    exec-once = waybar


    # Make 5 workspaces persistent
    workspace = 1, persistent:true
    workspace = 2, persistent:true
    workspace = 3, persistent:true
    workspace = 4, persistent:true
    workspace = 5, persistent:true

    exec-once = bash -c 'for i in {1..5}; do hyprctl dispatch workspace $i; done; hyprctl dispatch workspace 1'


    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################
    env = QT_QPA_PLATFORM,wayland
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    env = QT_AUTO_SCREEN_SCALE_FACTOR,1
    env = QT_QPA_PLATFORMTHEME,qt6ct

    env = OZONE_PLATFORM,wayland
    env = ELECTRON_OZONE_PLATFORM_HINT,wayland
    env = GDK_BACKEND,wayland,x11,*
    env = SDL_VIDEODRIVER,wayland
    env = CLUTTER_BACKEND,wayland
    env = MOZ_ENABLE_WAYLAND,1

    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland

    #####################
    ### LOOK AND FEEL ###
    #####################
    general {
        gaps_in     = 5
        gaps_out    = 5
        border_size = 2
        col.active_border   = 0xff${base0D}
        col.inactive_border = 0xff${base03}


        resize_on_border = false
        allow_tearing    = false
        layout           = dwindle
    }
    decoration {
        rounding         = 5
        active_opacity   = 0.95
        inactive_opacity = 0.95

        blur {
            enabled           = true
            size              = 3
            passes            = 3
            new_optimizations = true
            vibrancy          = 0.1696
            ignore_opacity    = true
        }
    }

    animations {
        enabled = true
        bezier = easeOutExpo, 0.16, 1, 0.3, 1

        animation = windowsIn, 1, 2, easeOutExpo, slide
        animation = windowsOut, 1, 2, easeOutExpo, slide
        animation = windowsMove, 1, 2, easeOutExpo, slide
        animation = fade, 1, 2, easeOutExpo
        animation = workspaces, 1, 3, easeOutExpo, slide
        animation = specialWorkspace, 1, 3, easeOutExpo, slidevert
        animation = layers, 1, 2, easeOutExpo, slidevert
    }

    dwindle {
        pseudotile     = false
        preserve_split = true
    }

    master {
    }

    misc {
        force_default_wallpaper = 0
        disable_hyprland_logo   = true
        disable_splash_rendering = true
    }


    #############
    ### INPUT ###
    #############
    input {
        # Keyboard
        kb_layout  = us,br
        kb_options = caps:escape

        # Mouse
        follow_mouse   = 1
        force_no_accel = 1
        sensitivity    = 0  # -1.0 to 1.0
    }


    #############################
    ## SOURCE EXTERNAL CONFIGS ##
    #############################
    source = ~/.config/hypr/keybinds.conf
    source = ~/.config/hypr/rules.conf

  '';

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${config.stylix.image}
    wallpaper = DP-1, ${config.stylix.image}
    wallpaper = Virtual-1, ${config.stylix.image}
    splash = false
    ipc = off

  '';
}
