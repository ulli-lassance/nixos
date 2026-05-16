{ ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        {
          _args = [ "NIXOS_OZONE_WL", "1" ];
        }
        {
          _args = [ "ELECTRON_OZONE_PLATFORM_HINT", "wayland" ];
        }

        {
          _args = [ "XDG_CURRENT_DESKTOP", "Hyprland" ];
        }
        {
          _args = [ "XDG_SESSION_TYPE", "wayland" ];
        }
        {
          _args = [ "XDG_SESSION_DESKTOP", "Hyprland" ];
        }

        {
          _args = [ "GDK_BACKEND", "wayland" ];
        }
        {
          _args = [ "GDK_SCALE", "1" ];
        }

        {
          _args = [ "CLUTTER_BACKEND", "wayland" ];
        }

        {
          _args = [ "QT_QPA_PLATFORM", "wayland" ];
        }
        {
          _args = [ "QT_WAYLAND_DISABLE_WINDOWDECORATION", "1" ];
        }
        {
          _args = [ "QT_AUTO_SCREEN_SCALE_FACTOR", "1" ];
        }
        {
          _args = [ "QT_SCALE_FACTOR", "1" ];
        }

        {
          _args = [ "MOZ_ENABLE_WAYLAND", "1" ];
        }
      ];
    };
  };
}
