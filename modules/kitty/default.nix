
{ config, pkgs, ... }:

{
  stylix.targets.kitty.enable = false;

  home.file = {
    ".config/kitty/kitty.conf".source = ./kitty.conf;
    ".config/kitty/scroll_mark.py".source = ./scroll_mark.py;
    ".config/kitty/search.py".source = ./search.py;

  };

  xdg.configFile."kitty/theme.conf".text = with config.lib.stylix.colors; ''
    # The basic colors
    foreground              #${base05}
    background              #${base00}
    selection_foreground    #${base00}
    selection_background    #${base06}

    # Cursor colors
    cursor                  #${base06}
    cursor_text_color       #${base00}

    # URL underline color when hovering with mouse
    url_color               #${base06}

    # Kitty window border colors
    active_border_color     #${base0D}
    inactive_border_color   #${base03}

    # OS Window titlebar colors
    wayland_titlebar_color system

    # Tab bar colors
    active_tab_foreground   #${base00}
    active_tab_background   #${base0D}
    inactive_tab_foreground #${base05}
    inactive_tab_background #${base01}
    tab_bar_background      #${base01}

    # The 16 terminal colors

    # black
    color0 #${base01}
    color8 #${base03}

    # red
    color1 #${base08}
    color9 #${base08}

    # green
    color2  #${base0B}
    color10 #${base0B}

    # yellow
    color3  #${base0A}
    color11 #${base0A}

    # blue
    color4  #${base0D}
    color12 #${base0D}

    # magenta
    color5  #${base0E}
    color13 #${base0E}

    # cyan
    color6  #${base0C}
    color14 #${base0C}

    # white
    color7  #${base05}
    color15 #${base06}

  '';

}
