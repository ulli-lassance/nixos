{ config, pkgs, ... }:

{
  stylix.targets.ghostty.enable = false;

  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      background-opacity = 1.00;
      confirm-close-surface = false;
      font-family = [
        "JetBrainsMono Nerd Font Mono"
        "Noto Color Emoji"
      ];
      font-size = 14;
      gtk-single-instance = true;
      window-inherit-working-directory = true;
      theme = "theme";
      window-decoration = false;
      window-padding-x = 8;
      window-padding-y = 8;
    };

    themes.theme = with config.lib.stylix.colors; {
      background = "${base00}";
      cursor-color = "${base05}";
      foreground = "${base05}";
      palette = [
        "0=#${base00}"
        "1=#${base08}"
        "2=#${base0B}"
        "3=#${base0A}"
        "4=#${base0D}"
        "5=#${base0E}"
        "6=#${base0C}"
        "7=#${base05}"
        "8=#${base02}"
        "9=#${base08}"
        "10=#${base0B}"
        "11=#${base0A}"
        "12=#${base0D}"
        "13=#${base0E}"
        "14=#${base0C}"
        "15=#${base07}"
      ];
      selection-background = "${base03}";
      selection-foreground = "${base05}";
    };

  };
}
