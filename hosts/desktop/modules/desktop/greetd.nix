{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        user = "greeter";
        command = lib.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--time-format '%H:%M'"
          "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
          "--asterisks"
          "--remember"
          "--remember-user-session"
        ];
      };
    };
  };
}
