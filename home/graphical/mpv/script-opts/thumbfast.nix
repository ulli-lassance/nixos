{ ... }:

{
  programs.mpv.scriptOpts.thumbfast = {
    socket = "";
    thumbnail = "";
    max_height = 200;
    max_width = 200;
    scale_factor = 1;
    tone_mapping = "auto";
    overlay_id = 42;
    spawn_first = true;
    quit_after_inactivity = 0;
    network = true;
    audio = false;
    hwdec = true;
    mpv_path = "mpv";

  };
}
