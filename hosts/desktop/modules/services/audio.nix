{ ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    # https://wiki.archlinux.org/title/PipeWire#Noticeable_audio_delay_or_audible_pop/crack_when_starting_playback
    wireplumber.extraConfig = {
      "10-disable-suspension" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_input.*"; }
              { "node.name" = "~alsa_output.*"; }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
        "monitor.bluez.rules" = [
          {
            matches = [
              { "node.name" = "~bluez_input.*"; }
              { "node.name" = "~bluez_output.*"; }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
      };
    };
  };
}
