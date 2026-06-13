{ config, ... }:
{
  services.mpd = {
    enable = true;
    settings = {
      music_directory = "${config.settings.user.home}/music";
    };
  };
}
