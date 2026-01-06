{ ... }:

{
  programs.mpv.bindings = {
    "MBTN_LEFT" = "cycle pause;script-message-to uosc flash-pause-indicator";
    "TAB" = "script-message-to uosc toggle-ui";
    "SPACE" = "cycle pause;script-message-to uosc flash-pause-indicator";
    "q" = "quit #! Quit";
    ";" = "playlist-prev";
    "'" = "playlist-next";

    "d" = "add speed 0.1";
    "s" = "add speed -0.1";
    "r" = "set speed 1.0";

    "1" = "add brightness -1";
    "2" = "add brightness +1";

    "3" = "add contrast -1";
    "4" = "add contrast +1";

    "5" = "add gamma -0.05";
    "6" = "add gamma +0.05";

    "7" = "add saturation -0.05";
    "8" = "add saturation +0.05";

    "ALT+d" = "cycle deband #! Video > Deband filter";
    "m" = "cycle mute #! Audio > Mute";
    "ALT+a" = "script-message-to uosc show-submenu-blurred \"Open\"";
    "ALT+z" = "script-message-to uosc show-submenu-blurred \"Audio\"";
    "ALT+x" = "script-message-to uosc show-submenu-blurred \"Subtitles\"";
    "ALT+s" = "script-message-to uosc show-submenu-blurred \"Video > Shaders\"";

    "/" = "script-binding console/enable #! Tools > Console";
    "CTRL+s" = "screenshot #! Tools > Screenshot";
    "i" = "script-binding stats/display-stats-toggle #! Tools > Display information and statistics";

    "MBTN_RIGHT" = "script-binding uosc/menu-blurred";
    "MOUSE_BTN2" = "script-binding uosc/menu-blurred";
    "b" = "script-binding uosc/open-file #! Open > Open File";
    "h" = "script-binding memo-history #! Open > Recently Played";
    "g" = "cycle interpolation #! Video > Toggle Interpolation";

    "CTRL+1" =
      "apply-profile high-quality;show-text \"Profile: high-quality\" #! Video > Profiles > high-quality";
    "CTRL+2" = "apply-profile fast;show-text \"Profile: fast\" #! Video > Profiles > fast";

    "F1" =
      "af toggle \"lavfi=[loudnorm=I=-14:TP=-3:LRA=4]\" ; show-text \"\${af}\" #! Audio > Dialogue filter";

    "y" = "script-binding uosc/subtitles #! Subtitles > Select";
    "j" = "add sub-scale +0.05 #! Subtitles > Bigger";
    "k" = "add sub-scale -0.05 #! Subtitles > Smaller";
    "z" = "add sub-delay -0.1 #! Subtitles > Decrease Sub Delay";
    "x" = "add sub-delay  0.1 #! Subtitles > Increase Sub Delay";

    "WHEEL_UP" = "add volume 5 #! Audio > Increase volume";
    "WHEEL_DOWN" = "add volume -5 #! Audio > Decrease volume";
    "RIGHT" = "seek  5";
    "LEFT" = "seek -5";
    "UP" = "seek  60";
    "DOWN" = "seek -60";

    "f" = "cycle fullscreen";
    "MBTN_LEFT_DBL" = "cycle fullscreen";
    "ESC" = "set fullscreen no";
  };
}
