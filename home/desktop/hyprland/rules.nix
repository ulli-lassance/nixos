{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "suppress_event maximize, match:class .*"

      "float on, match:class ^(firefox)$, match:title (Picture-in-Picture)"
      "size 720 405, match:title (Picture-in-Picture)"

      "float on, match:class ^(xdg-desktop-portal-gtk)$"
      "float on, match:class ^(xdg-desktop-portal-hyprland)$"
      "float on, match:class ^(org.kde.ark)$"
      "float on, match:class ^(org.gnome.FileRoller)$"
      "float on, match:class ^(org.gnome.seahorse.Application)$"
      "float on, match:class ^(qalculate-gtk)$"

      "float on, size 900 700, center on, match:class ^(pavucontrol-qt)$"
      "float on, size 900 700, center on, match:class ^(org.pulseaudio.pavucontrol)$"

      "float on, size 670 760, match:title ^(Remmina Remote Desktop Client)$"

      "float on, match:class ^(qt6ct)$"
      "float on, match:class ^(qt5ct)$"
      "float on, match:title ^(Kvantum Manager)$"

      # Gaming
      "fullscreen on, match:class ^(ffxiv_dx11.exe)$"
      "fullscreen on, match:title ^(Overwatch)$"
    ];

    # Layer Rules
    layerrule = [
      "match:namespace ^(rofi)$,dim_around on"
      "match:namespace hyprpicker,no_anim on"
      "match:namespace selection,no_anim on"
      "match:namespace slurp,no_anim on"
    ];
  };
}
