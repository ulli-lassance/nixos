{ ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "NIXOS_OZONE_WL, 1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"

        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"

        "GDK_BACKEND, wayland"
        "GDK_SCALE,1"

        "CLUTTER_BACKEND, wayland"

        "QT_QPA_PLATFORM, wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "QT_SCALE_FACTOR,1"

        "MOZ_ENABLE_WAYLAND, 1"
      ];
    };
  };
}
