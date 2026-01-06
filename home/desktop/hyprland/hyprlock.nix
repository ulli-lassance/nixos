{
  pkgs,
  config,
  vars,
  ...
}:

{
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;
    settings = with config.lib.stylix.colors; {
      general = {
        hide_cursor = true;
      };
      background = [
        {
          path = "${./../../../assets/wallpapers + "/${vars.wallpaper}"}";
          color = "rgb(${base00})";
          blur_passes = 3;
          blur_size = 3;
        }
      ];

      animations = {
        enabled = true;
        bezier = [
          "linear, 1, 1, 0, 0"
        ];

        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      input-field = [
        {
          dots_center = true;
          fade_on_empty = true;
          size = "250, 50";
          position = "0, -60";
          font_color = "rgb(${base05})";
          inner_color = "rgb(${base00})";
          outer_color = "rgb(${base03})";
          check_color = "rgb(${base0A})";
          fail_color = "rgb(${base08})";
          outline_thickness = 2;
          placeholder_text = "";
          shadow_passes = 2;
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          text = "$TIME";
          font_size = 120;
          font_family = "Noto Sans SemiBold";
          color = "rgb(${base05})";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
