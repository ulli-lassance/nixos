{ config, ... }:

{
  programs.mpv = with config.lib.stylix.colors; {
    config = {
      input-default-bindings = false;

      # video
      vo = "gpu-next";
      hwdec = "auto";
      gpu-api = "vulkan";
      deinterlace = "auto";
      deband = true;
      deband-iterations = 2;
      deband-threshold = 48;
      deband-range = 32;
      deband-grain = 32;
      tscale = "oversample";
      keep-open = true;

      # audio and subtitles
      slang = "en,eng,English";
      alang = "ja,jp,jpn,jap,Japanese,en,eng,English";
      sub-blur = 0.5;
      sub-gauss = 1.5;
      sub-scale = 1;
      sub-margin-y = 60;
      sub-color = "#ffffffff";
      sub-shadow-offset = 0;
      sub-outline-size = 1.15;
      sub-font = "Noto Sans Bold";
      sub-back-color = "#${base00}";
      sub-border-color = "#${base00}";
      sub-shadow-color = "#${base00}";
      sub-outline-color = "#${base00}";
      sub-auto = "all";
      volume = 30;
      volume-max = 200;
      sub-fix-timing = true;
      sub-ass-override = "strip";
      demuxer-mkv-subtitle-preroll = true;
      sub-file-paths = "sub;subs;subtitles";

      # UI / OSD
      osc = false;
      border = false;
      cursor-autohide = 1000;
      osd-level = 1;
      osd-bar = false;
      osd-bold = true;
      osd-font-size = 37;
      osd-font = "JetBrains Mono";
      osd-duration = 1000;

      # screenshots
      screenshot-format = "png";
      screenshot-high-bit-depth = false;
      screenshot-tag-colorspace = false;
      screenshot-png-compression = 2;
      screenshot-dir = "~/Pictures/Screenshots";
      screenshot-template = "%{?demuxer-via-network==yes:\${media-title}%{?demuxer-via-network==yes:_\${filename/no-ext}%{!demuxer-via-network==yes:\${filename}-%wH.%wM.%wS.%wT-#%#00n";

      # cache
      cache = true;
      cache-pause = false;
      demuxer-max-bytes = "500M";
      demuxer-max-back-bytes = "100M";
    };
  };
}
