{ config, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.settings.user.home}/music";

  };
}
