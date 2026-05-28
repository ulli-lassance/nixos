{ config, lib, ... }:

let
  cfg = config.settings.defaultApps;

  # media
  imageTypes = [
    "image/jpeg"
    "image/png"
    "image/gif"
    "image/webp"
    "image/avif"
    "image/bmp"
    "image/heif"
    "image/tiff"
    "image/x-icns"
    "image/svg+xml"
  ];

  audioTypes = [
    "audio/aac"
    "audio/flac"
    "audio/mp4"
    "audio/mpeg"
    "audio/mpegurl"
    "audio/ogg"
    "audio/wav"
    "audio/vnd.rn-realaudio"
  ];

  videoTypes = [
    "video/mp4"
    "video/x-matroska"
    "video/webm"
    "video/quicktime"
    "video/x-flv"
    "video/x-msvideo"
  ];

  # web and remote desktop
  webTypes = [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
    "x-scheme-handler/mailto"
  ];

  remoteDesktopTypes = [
    "x-scheme-handler/rdp"
    "x-scheme-handler/remmina"
    "x-scheme-handler/spice"
    "x-scheme-handler/vnc"
    "application/x-remmina"
  ];

  # text
  textTypes = [
    "text/plain"
    "text/markdown"
    "inode/x-empty"
    "application/x-zerosize"
    "application/json"
    "application/yaml"
    "application/x-yaml"
    "application/x-shellscript"
    "text/x-cmake"
    "application/x-docbook+xml"
    "text/css"
    "text/javascript"
    "text/x-python"
    "text/x-go"
    "application/toml"
  ];

  # archive and files
  archiveTypes = [
    "application/zip"
    "application/gzip"
    "application/x-tar"
    "application/x-bzip2"
    "application/x-7z-compressed"
    "application/x-rar-compressed"
    "application/x-xz"
    "application/zstd"
  ];

  directoryTypes = [
    "inode/directory"
  ];

  # misc
  pdfTypes = [
    "application/pdf"
  ];

  discordTypes = [
    "x-scheme-handler/discord"
  ];

in
{
  options.settings.defaultApps = {
    browser = lib.mkOption {
      type = lib.types.str;
      default = "brave-origin-nightly.desktop";
    };
    imageViewer = lib.mkOption {
      type = lib.types.str;
      default = "imv-dir.desktop";
    };
    videoPlayer = lib.mkOption {
      type = lib.types.str;
      default = "mpv.desktop";
    };
    audioPlayer = lib.mkOption {
      type = lib.types.str;
      default = "mpv.desktop";
    };
    textEditor = lib.mkOption {
      type = lib.types.str;
      default = "codium.desktop";
    };
    pdfViewer = lib.mkOption {
      type = lib.types.str;
      default = "org.gnome.Papers.desktop";
    };
    fileManager = lib.mkOption {
      type = lib.types.str;
      default = "thunar.desktop";
    };
    remoteDesktop = lib.mkOption {
      type = lib.types.str;
      default = "org.remmina.Remmina.desktop";
    };
    archiveManager = lib.mkOption {
      type = lib.types.str;
      default = "org.gnome.FileRoller.desktop";
    };
    discord = lib.mkOption {
      type = lib.types.str;
      default = "vesktop.desktop";
    };
  };

  config = {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = lib.mkMerge [
        (lib.genAttrs imageTypes (_: [ cfg.imageViewer ]))
        (lib.genAttrs audioTypes (_: [ cfg.audioPlayer ]))
        (lib.genAttrs videoTypes (_: [ cfg.videoPlayer ]))

        (lib.genAttrs webTypes (_: [ cfg.browser ]))
        (lib.genAttrs remoteDesktopTypes (_: [ cfg.remoteDesktop ]))

        (lib.genAttrs textTypes (_: [ cfg.textEditor ]))

        (lib.genAttrs archiveTypes (_: [ cfg.archiveManager ]))
        (lib.genAttrs directoryTypes (_: [ cfg.fileManager ]))

        (lib.genAttrs pdfTypes (_: [ cfg.pdfViewer ]))
        (lib.genAttrs discordTypes (_: [ cfg.discord ]))
      ];
    };
  };
}
