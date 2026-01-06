{ lib, ... }:

let
  # Applications
  browser = [ "firefox.desktop" ];
  imageViewer = [
    "imv-dir.desktop"
    "firefox.desktop"
  ];
  videoPlayer = [ "mpv.desktop" ];
  audioPlayer = [ "mpv.desktop" ];
  textEditor = [ "codium.desktop" ];
  pdfViewer = [
    "org.gnome.Evince.desktop"
    "firefox.desktop"
  ];
  fileManager = [ "nemo.desktop" ];
  remoteDesktop = [ "org.remmina.Remmina.desktop" ];
  archiveManager = [ "org.gnome.FileRoller.desktop" ];

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

  documentTypes = [
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    "application/vnd.openxmlformats-officedocument.presentationml.presentation"
  ];

in
{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = lib.mkMerge [
      (lib.genAttrs imageTypes (_: imageViewer))
      (lib.genAttrs audioTypes (_: audioPlayer))
      (lib.genAttrs videoTypes (_: videoPlayer))

      {
        # Web
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "x-scheme-handler/mailto" = browser;

        # Archives
        "application/zip" = archiveManager;
        "application/gzip" = archiveManager;
        "application/x-tar" = archiveManager;
        "application/x-bzip2" = archiveManager;
        "application/x-7z-compressed" = archiveManager;
        "application/x-rar-compressed" = archiveManager;
        "application/x-xz" = archiveManager;

        # Text
        "text/plain" = textEditor;
        "text/markdown" = textEditor;
        "inode/x-empty" = textEditor;
        "application/x-zerosize" = textEditor;
        "application/json" = textEditor;
        "application/x-yaml" = textEditor;
        "application/x-shellscript" = textEditor;
        "text/x-cmake" = textEditor;
        "application/x-docbook+xml" = textEditor;
        "text/css" = textEditor;
        "text/javascript" = textEditor;
        "text/x-python" = textEditor;
        "text/x-go" = textEditor;
        "application/toml" = textEditor;

        # PDF
        "application/pdf" = pdfViewer;

        # Remote Desktop
        "x-scheme-handler/rdp" = remoteDesktop;
        "x-scheme-handler/remmina" = remoteDesktop;
        "x-scheme-handler/spice" = remoteDesktop;
        "x-scheme-handler/vnc" = remoteDesktop;
        "application/x-remmina" = remoteDesktop;

        # Directories
        "inode/directory" = fileManager;

        # Misc
        "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      }
    ];
  };
}
