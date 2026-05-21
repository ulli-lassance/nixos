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
    "audio/mp4"
    "audio/mpeg"
    "audio/mpegurl"
    "audio/ogg"
    "audio/x-flac"
    "audio/x-mp3"
    "audio/x-wav"
    "audio/x-vorbis+ogg"
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

  # office
  wordTypes = [
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" # docx
    "application/msword" # doc
    "application/vnd.oasis.opendocument.text" # odt
  ];

  spreadsheetTypes = [
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" # xlsx
    "application/vnd.ms-excel" # xls
    "application/vnd.oasis.opendocument.spreadsheet" # ods
  ];

  presentationTypes = [
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" # pptx
    "application/vnd.ms-powerpoint" # ppt
    "application/vnd.oasis.opendocument.presentation" # odp
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
  ];

  directoryTypes = [
    "inode/directory"
    "application/x-gnome-saved-search"
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
    wordProcessor = lib.mkOption {
      type = lib.types.str;
      default = "writer.desktop";
    };
    spreadsheet = lib.mkOption {
      type = lib.types.str;
      default = "calc.desktop";
    };
    presentation = lib.mkOption {
      type = lib.types.str;
      default = "impress.desktop";
    };
  };

  config = {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = lib.mkMerge [
        (lib.genAttrs imageTypes (_: [ cfg.imageViewer ]))
        (lib.genAttrs audioTypes (_: [ cfg.audioPlayer ]))
        (lib.genAttrs videoTypes (_: [ cfg.videoPlayer ]))

        (lib.genAttrs wordTypes (_: [ cfg.wordProcessor ]))
        (lib.genAttrs spreadsheetTypes (_: [ cfg.spreadsheet ]))
        (lib.genAttrs presentationTypes (_: [ cfg.presentation ]))

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
