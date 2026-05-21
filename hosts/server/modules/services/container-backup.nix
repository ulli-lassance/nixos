{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.containerVolumeBackup;
in
{
  options.services.containerVolumeBackup = {
    enable = mkEnableOption "container volume rsync backup service";

    source = mkOption {
      type = types.path;
      default = config.settings.server.volumeDirectory;
      description = "the directory containing the container volumes to backup.";
    };

    destination = mkOption {
      type = types.path;
      description = "the destination directory.";
    };

    keepPruned = mkOption {
      type = types.bool;
      default = true;
      description = "whether to use --delete to mirror the source directory.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.container-volume-backup = {
      description = "container volumes backup service";

      after = [ "local-fs.target" ];

      before = [
        "docker.service"
        "podman.service"
      ];

      requiredBy = [
        "docker.service"
        "podman.service"
      ];

      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.rsync ];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        TimeoutStartSec = "300";
      };

      script = ''
        echo "starting Pre-Boot container backup..."

        # Ensure destination exists
        mkdir -p "${cfg.destination}"

        DELETE_FLAG=""
        if [ "${toString cfg.keepPruned}" = "1" ]; then
          DELETE_FLAG="--delete"
        fi

        # Run rsync
        # -a: archive (preserve all permissions/times)
        # -h: human readable
        # --stats: print transfer stats to log
        rsync -ah --stats $DELETE_FLAG "${cfg.source}/" "${cfg.destination}/"

        echo "backup completed."
      '';
    };
  };
}
