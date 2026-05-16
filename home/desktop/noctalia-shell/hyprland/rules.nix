{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    window_rule = [
      {
        match = { class = ".*"; };
        suppress_event = "maximize";
      }

      {
        match = { title = "(?i)picture[- ]in[- ]picture"; };
        float = true;
      }
      {
        match = { title = "(?i)picture[- ]in[- ]picture"; };
        size = { 720, 405 };
      }

      {
        match = { class = "^(xdg-desktop-portal-gtk)$"; };
        float = true;
      }
      {
        match = { class = "^(xdg-desktop-portal-hyprland)$"; };
        float = true;
      }
      {
        match = { class = "^(org.gnome.FileRoller)$"; };
        float = true;
      }
      {
        match = { class = "^(org.gnome.seahorse.Application)$"; };
        float = true;
      }
      {
        match = { class = "^(qalculate-gtk)$"; };
        float = true;
      }

      {
        match = { class = "^(pavucontrol-qt)$"; };
        float = true;
        size = { 900, 700 };
        center = true;
      }
      {
        match = { class = "^(org.pulseaudio.pavucontrol)$"; };
        float = true;
        size = { 900, 700 };
        center = true;
      }

      {
        match = { title = "^(Remmina Remote Desktop Client)$"; };
        float = true;
        size = { 670, 760 };
      }

      {
        match = { class = "^(qt6ct)$"; };
        float = true;
      }
      {
        match = { class = "^(qt5ct)$"; };
        float = true;
      }
      {
        match = { title = "^(Kvantum Manager)$"; };
        float = true;
      }

      # Gaming
      {
        match = { class = "^(ffxiv_dx11.exe)$"; };
        fullscreen = true;
      }
      {
        match = { title = "^(Overwatch)$"; };
        fullscreen = true;
      }
    ];

    layer_rule = [
      {
        match = { namespace = "hyprpicker"; };
        animation = "fade";
      }
      {
        match = { namespace = "selection"; };
        animation = "fade";
      }
      {
        match = { namespace = "slurp"; };
        animation = "fade";
      }

      {
        match = { namespace = "^noctalia-background-.*$"; };
        ignore_alpha = 0.5;
      }
      {
        match = { namespace = "^noctalia-background-.*$"; };
        blur = true;
      }
      {
        match = { namespace = "^noctalia-background-.*$"; };
        blur_popups = true;
      }
    ];
  };
}