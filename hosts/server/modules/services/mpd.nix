{ config, ... }:
{
  services.mpd = {
    enable = true;
    user = config.settings.user.username; # so it can read music
    settings = {
      music_directory = "${config.settings.user.home}/music";
      port = 6600;
    };
    
    openFirewall = true;
  };
}
