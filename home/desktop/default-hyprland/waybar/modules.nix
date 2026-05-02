{
  # Workspaces
  "hyprland/workspaces" = {
    format = "{icon}";
    format-icons = {
      active = "";
      default = "";
      empty = "";
    };
    persistent-workspaces = {
      "*" = 5;
    };
    all-outputs = false;
  };

  # System Tray
  tray = {
    icon-size = 24;
    spacing = 8;
    show-passive-items = true;
  };

  # Active Window Title
  "hyprland/window" = {
    format = "<span weight='bold'>{class}</span>";
    max-length = 120;
    icon = false;
  };

  # Taskbar (WLR)
  "wlr/taskbar" = {
    all-outputs = false;
    active-first = false;
    markup = true;
    format = "{icon}";
    rotate = 0;
    icon-size = 24;
    spacing = 0;
    tooltip-format = "{title}";
    on-click = "activate";
    on-click-middle = "close";
  };

  # Keyboard Language
  "hyprland/language" = {
    format = "󰌌 {}";
    format-pt = "br";
    format-en = "eng";
    tooltip-format = "Keyboard Layout";
    on-click = "~/.config/hypr/scripts/cycle_kb_layout";
  };

  # Network
  network = {
    tooltip = true;
    format-wifi = "  {essid} ";
    format-ethernet = "󰈀 ";
    tooltip-format = "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
    format-linked = "󰈀 {ifname} (No IP) ";
    format-disconnected = "󱘖 ";
    tooltip-format-disconnected = "Disconnected";
  };

  # PulseAudio Output
  "pulseaudio#output" = {
    format = "{icon} {volume}% ";
    format-bluetooth = "{icon}  {volume}% ";
    format-muted = " Muted ";
    format-icons = {
      default = [
        ""
        ""
        ""
        ""
      ];
    };
    on-click = "pamixer -t";
    on-scroll-up = "pamixer -i 5";
    on-scroll-down = "pamixer -d 5";
    tooltip = false;
    scroll-step = 5;
  };

  # PulseAudio Input
  "pulseaudio#input" = {
    format = "{format_source}";
    format-source = " {volume}%";
    format-source-muted = " Muted";
    on-click = "pamixer --default-source -t";
    on-scroll-up = "pamixer --default-source -i 5";
    on-scroll-down = "pamixer --default-source -d 5";
    tooltip = false;
    scroll-step = 5;
  };

  # Media Player
  mpris = {
    format = " {status_icon} {dynamic}";
    dynamic-len = 50;
    status-icons = {
      playing = "";
      paused = "";
    };
    dynamic-order = [
      "title"
      "artist"
    ];
  };

  # CPU
  cpu = {
    format = " {usage}% ";
    interval = 1;
  };

  # RAM
  "memory#ram" = {
    format = " {percentage}%";
    interval = 1;
    tooltip-format = "{used}/{total} GiB";
  };

  # Temperature
  temperature = {
    interval = 10;
    # Ensure this path exists on your specific hardware.
    hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input";
    critical-threshold = 95;
    format = "{icon} {temperatureC}°C";
    format-icons = [
      ""
      ""
      ""
      ""
      ""
    ];
    tooltip = false;
  };

  # Clock
  clock = {
    format = "{:%A %d/%m - %I:%M %p}";
    interval = 1;
    tooltip-format = "<tt>{calendar}</tt>";
  };

  # Custom Power Menu
  "custom/power" = {
    on-click = "~/.config/rofi/scripts/toggle-power-menu";
    format = "";
    tooltip = false;
  };

  # Borders (Spacers)
  "custom/l_border" = {
    format = " ";
    interval = "once";
    tooltip = false;
  };

  "custom/r_border" = {
    format = " ";
    interval = "once";
    tooltip = false;
  };
}
