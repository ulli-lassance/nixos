{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.settings = {
    user = {
      username = mkOption { type = types.str; };
      home = mkOption {
        type = types.str;
        default = "/home/${config.settings.user.username}";
        description = "home path";
      };
      name = mkOption {
        type = types.str;
        default = "${config.settings.user.username}";
        description = "for git auth";
      };
      email = mkOption {
        type = types.str;
        description = "for git auth";
      };
    };

    network = {
      hostName = mkOption { type = types.str; };
    };

    stateVersion = mkOption {
      type = types.str;
      default = "26.05";
    };

    timezone = mkOption {
      type = types.str;
      default = "America/Sao_Paulo";
    };

    theme = {
      colors = mkOption {
        type = types.str;
        default = "rose-pine";
        description = "color theme file to use";
      };
      wallpaper = mkOption {
        type = types.str;
        default = "moon.jpg";
        description = "wallpaper to use";
      };
    };
  };
}
