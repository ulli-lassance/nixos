{ pkgs, vars, ... }:

{
  systemd.timers."podman-auto-update" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."podman-auto-update" = {
    description = "Dynamic Podman auto-update for rootless NixOS containers";
    serviceConfig = {
      Type = "oneshot";
    };
    
    # Provide the necessary tools to the script's environment
    path = with pkgs; [ sudo podman gnugrep systemd ];
    
    script = ''
      echo "starting rootless container update check..."

      # find all running containers owned by the user that have the autoupdate label.
      # output format: ContainerName ImageURL
      CONTAINERS=$(sudo -u ${vars.username} podman ps --filter "label=io.containers.autoupdate=registry" --format "{{.Names}} {{.Image}}")

      # read through the list line by line
      echo "$CONTAINERS" | while read -r NAME IMAGE; do
        # skip if the line is empty
        if [ -z "$NAME" ]; then continue; fi
        
        echo "Checking updates for $NAME ($IMAGE)..."
        
        # pull the latest image as unprivileged user
        OUTPUT=$(sudo -u ${vars.username} podman pull "$IMAGE" 2>&1)

        # look for podman success strings in the output
        if echo "$OUTPUT" | grep -E -q "(Downloaded newer image|Writing manifest)"; then
          echo "new image pulled for $NAME. restarting systemd service..."
          
          systemctl restart "podman-$NAME.service"
        else
          echo "no updates available for $NAME."
        fi
      done

      echo "cleaning up old images..."
      sudo -u ${vars.username} podman image prune -f
      
      echo "update process complete"
    '';
  };
}