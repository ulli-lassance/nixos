{ config, pkgs, ... }:

{
  stylix.targets.dunst.enable = false;

  xdg.configFile."dunst/dunstrc".text = with config.lib.stylix.colors; ''
    [global]
    # --- Display & Position ---
        monitor = 0                   # Which monitor to use (0 = primary)
        follow = none                # Show notifications near the mouse cursor
        origin = top-right            # Notification corner position
        offset = (5,5)                # X and Y offset from screen edge
        width = (300,400)             # Min/max width range for notifications
        height = (0, 250)             # Max height of notification window

    # --- Appearance ---
        transparency = 0              # 0 = opaque, higher = more transparent
        corner_radius = 5             # Rounded corner radius (0 for square)
        padding = 12                  # Space between text and window border
        horizontal_padding = 12       # Additional left/right padding
        separator_height = 2          # Space between stacked notifications
        frame_width = 2               # Border thickness
        frame_color = "#${base0D}"    # Border color
        separator_color = frame       # Separator uses frame color
        font = JetBrainsMono Nerd Font Bold 12  # Font and size
        line_height = 0               # 0 = auto
        markup = full                 # Enable pango markup for formatting text
        alignment = left              # Text alignment (left, center, right)
        format = "<b>%s</b>\n%b"      # Notification format: title + body
        word_wrap = yes               # Wrap long text
        ellipsize = middle            # Ellipsize long lines in the middle
        progress_bar_corner_radius = 2  # Roundness of the bar itself

    # --- Behavior ---
        indicate_hidden = yes         # Show indicator if notifications are hidden
        sort = yes                    # Sort notifications by urgency
        idle_threshold = 0          # Delay timeout if idle > seconds
        show_age_threshold = -1       # Show how old a notification is after 60s
        ignore_newline = no           # Keep newlines in notifications
        stack_duplicates = true       # Combine duplicate notifications
        hide_duplicate_count = false  # Show duplicate count
        show_indicators = no          # Disable progress indicators
        sticky_history = no           # Don't keep notifications on restart
        always_run_script = true      # Always run scripts (for rules, etc.)

    # --- Icons ---
        icon_position = left          # Icon placement relative to text
        min_icon_size = 50            # Minimum icon size
        max_icon_size = 50            # Maximum icon size
        enable_recursive_icon_lookup = true

    # --- Mouse Actions ---
      mouse_left_click = close_current
      mouse_middle_click = do_action, close_current
      mouse_right_click = close_all

    # --- Urgency Levels ---
    [urgency_low]
        background = "#${base00}"
        foreground = "#${base05}"
        highlight = "#${base0D}"
        timeout = 5               # Auto-dismiss after 5s

    [urgency_normal]
        background = "#${base00}"
        foreground = "#${base05}"
        highlight = "#${base0D}"
        timeout = 5               # Auto-dismiss after 5s

    [urgency_critical]
        background = "#${base00}"
        foreground = "#${base05}"
        frame_color = "#${base08}"
        highlight = "#${base0D}"
        timeout = 0               # Stays until manually dismissed  
  '';

}
