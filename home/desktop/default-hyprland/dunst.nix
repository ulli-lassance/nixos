{ config, pkgs, ... }:

{
  stylix.targets.dunst.enable = false;

  home.packages = with pkgs; [
    adwaita-icon-theme # Default icon fallback
  ];

  services.dunst = {
    enable = true;

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
      size = "48x48";
    };

    settings = with config.lib.stylix.colors; {
      global = {
        monitor = 0;
        follow = "mouse";
        offset = "(5,5)";
        width = "(300,400)";
        height = "(0, 250)";

        transparency = 0;
        corner_radius = 5;
        padding = 12;
        horizontal_padding = 12;
        separator_height = 2;
        frame_width = 2;
        frame_color = "#${base0D}";
        separator_color = "#${base0D}";

        font = "JetBrainsMono Nerd Font Bold 12";
        line_height = 0;
        markup = "full";
        alignment = "left";
        format = "<b>%s</b>\\n%b";
        word_wrap = "yes";
        ellipsize = "middle";
        progress_bar_corner_radius = 2;

        indicate_hidden = "yes";
        sort = "yes";
        idle_threshold = 0;
        show_age_threshold = -1;
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "no";
        sticky_history = "no";
        always_run_script = true;

        icon_position = "left";
        min_icon_size = 48;
        max_icon_size = 48;
        enable_recursive_icon_lookup = true;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        background = "#${base00}";
        foreground = "#${base05}";
        highlight = "#${base0D}";
        timeout = 5;
      };

      urgency_normal = {
        background = "#${base00}";
        foreground = "#${base05}";
        highlight = "#${base0D}";
        timeout = 5;
      };

      urgency_critical = {
        background = "#${base00}";
        foreground = "#${base05}";
        frame_color = "#${base08}";
        highlight = "#${base0D}";
        timeout = 0;
      };
    };
  };
}
