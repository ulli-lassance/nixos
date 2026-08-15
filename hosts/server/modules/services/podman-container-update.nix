{
  pkgs,
  config,
  ...
}:
{
  users.users."${config.settings.user.username}".linger = true;

  systemd.timers."podman-auto-update" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."podman-auto-update" = {
    description = "podman auto-update for rootless nixos containers";
    serviceConfig = {
      Type = "oneshot";
    };

    path = with pkgs; [
      sudo
      podman
      systemd
      coreutils
    ];

    script = ''
      set -euo pipefail

      echo "starting rootless container update check..."

      USER="${config.settings.user.username}"
      USER_UID=$(id -u "$USER")
      RUNTIME_DIR="/run/user/$USER_UID"

      if [ ! -d "$RUNTIME_DIR" ]; then
        echo "error: $RUNTIME_DIR does not exist. Is linger enabled?"
        exit 1
      fi

      PODMAN_CMD="sudo -u $USER env XDG_RUNTIME_DIR=$RUNTIME_DIR podman"

      mapfile -t CONTAINERS < <($PODMAN_CMD ps --filter "label=io.containers.autoupdate=registry" --format "{{.Names}} {{.Image}}")

      for line in "''${CONTAINERS[@]}"; do
        if [ -z "$line" ]; then continue; fi
        
        read -r NAME IMAGE <<< "$line"

        echo "checking updates for $NAME ($IMAGE)..."

        OLD_DIGEST=$($PODMAN_CMD image inspect "$IMAGE" --format '{{.Digest}}' 2>/dev/null || echo "none")
        $PODMAN_CMD pull "$IMAGE" -q > /dev/null
        NEW_DIGEST=$($PODMAN_CMD image inspect "$IMAGE" --format '{{.Digest}}' 2>/dev/null || echo "none")

        if [ "$OLD_DIGEST" != "$NEW_DIGEST" ] && [ "$NEW_DIGEST" != "none" ]; then
          echo "new image pulled for $NAME. restarting systemd service..."
          systemctl restart "podman-$NAME.service"
        else
          echo "no updates available for $NAME."
        fi
      done

      echo "cleaning up images..."
      $PODMAN_CMD image prune -af

      echo "update process complete."
    '';
  };
}
