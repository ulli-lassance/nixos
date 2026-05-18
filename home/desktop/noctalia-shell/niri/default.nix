{ pkgs, config, ... }:

{
  # xdg.configFile = {
  #   "niri" = {
  #     source = ./config;
  #     recursive = true;
  #   };
  # };

  xdg.configFile = with config.lib.stylix.colors.withHashtag; {
    "niri/colors.kdl".text = ''
      layout {
          shadow {
              color "${base00}"
          }

          border {
              active-color "${base0D}"
              inactive-color "${base03}"

              urgent-color "${base08}"
          }
      }

      recent-windows {
          highlight {
              active-color "${base0D}"
              urgent-color "${base08}"
          }
      }

      overview {
          backdrop-color "${base00}"
      }
    '';

    "niri/config.kdl".source = ./config/config.kdl;
    "niri/animations.kdl".source = ./config/animations.kdl;
    "niri/rules.kdl".source = ./config/rules.kdl;
    "niri/binds.kdl".source = ./config/binds.kdl;
    "niri/env.kdl".source = ./config/env.kdl;

  };
}
