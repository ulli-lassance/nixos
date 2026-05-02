{ config, pkgs, ... }:

{
  stylix.targets.rofi.enable = false;

  home.packages = with pkgs; [
    rofi
  ];

  home.file = {
    ".config/rofi/scripts" = {
      source = ./scripts;
      recursive = true;
    };

    ".config/rofi/modes" = {
      source = ./modes;
      recursive = true;
    };

  };
  xdg.configFile."rofi/config.rasi".text = ''
    @theme "~/.config/rofi/modes/main.rasi"
  '';

  xdg.configFile."rofi/colors.rasi".text = with config.lib.stylix.colors; ''
    * {
    background: #${base00}; 
    bg-select: #${base02};
    text: #${base05};
    alt-background: #${base01};
    border: #${base0D};
    transparent: #00000000;
    }
  '';
}
