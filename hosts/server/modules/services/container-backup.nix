{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

with lib;

let
  cfg = config.services.containerVolumeBackup;
in
{
  options.services.containerVolumeBackup = {
    enable = mkEnableOption "Container volume rsync backup service";

    source = mkOption {
      type = types.path;
      description = "The directory containing the container volumes to backup.";
    };

    destination = mkOption {
      type = types.path;
      description = "The destination directory.";
    };

    keepPruned = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use --delete to mirror the source directory.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.container-volume-backup = {
      description = "Container volumes backup service";

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
        RequiresMountsFor = [
          cfg.source
          cfg.destination
        ];
      };

      script = ''
        echo "Starting Pre-Boot container backup..."

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

        echo "Backup completed."
      '';
    };
  };
}
