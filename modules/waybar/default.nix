{ config, pkgs, ... }:

{
  stylix.targets.waybar.enable = false;

  home.file = {
    ".config/waybar/modules.jsonc".source = ./modules.jsonc;
    ".config/waybar/config.jsonc".source = ./config.jsonc;

    ".config/waybar/scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };

  xdg.configFile."waybar/style.css".text = with config.lib.stylix.colors; ''
    @define-color background #${base00};   /* base00 */
    @define-color bg-select #${base02};    /* base02 */
    @define-color text #${base05};         /* base05 */
    @define-color border #${base0D};       /* base0D */
    @define-color text-select #${base0D};  /* base0D */

  '' + builtins.readFile ./style.css;
}