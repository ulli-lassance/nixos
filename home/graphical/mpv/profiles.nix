{ ... }:

{
  programs.mpv.profiles = {

    "high-quality" = {
      scale = "ewa_lanczossharp";
      hdr-peak-percentile = 99.995;
      hdr-contrast-recovery = 0.30;
    };

    "fast" = {
      scale = "bilinear";
      dscale = "bilinear";
      dither = "no";
      correct-downscaling = "no";
      linear-downscaling = "no";
      sigmoid-upscaling = "no";
      hdr-compute-peak = "no";
      allow-delayed-peak-detect = "yes";
    };
  };
}
