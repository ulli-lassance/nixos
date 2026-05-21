{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.settings.desktop.applications = {
    browser = mkOption {
      type = types.str;
      default = "brave-origin";
    };
    editor = mkOption {
      type = types.str;
      default = "codium";
    };
    terminal = mkOption {
      type = types.str;
      default = "kitty";
    };
    fileManager = mkOption {
      type = types.str;
      default = "thunar";
    };
  };
}
