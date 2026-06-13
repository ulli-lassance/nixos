{ config, ... }:
{
  services.mpd = {
    enable = true;
    user = config.settings.user.username; # so it can read music
    settings = {
      music_directory = "${config.settings.user.home}/music";
      auto_update = "yes";
      port = 6600;
      bind_to_address = "any";

      # audio_output = [
      #   {
      #     type = "pipewire";
      #     name = "PipeWire Output";
      #     mixer_type = "software";
      #   }
      # ];
    };

    openFirewall = true;
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };
}
