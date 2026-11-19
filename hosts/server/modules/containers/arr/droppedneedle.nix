{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/droppedneedle 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/droppedneedle/config 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/droppedneedle/cache 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/droppedneedle/plugins 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/droppedneedle/imports 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    droppedneedle = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "docker.io/droppedneedle/droppedneedle:latest";

      podman.user = config.settings.user.username;

      environment = {
        TZ = config.time.timeZone;
        PORT = "8688";
        UMASK = "027";
        SLSKD_DOWNLOADS_PATH = "/data/soulseek/complete";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/droppedneedle/config:/app/config"
        # This contains the database and backups, not just disposable cache.
        "${config.settings.server.volumeDirectory}/droppedneedle/cache:/app/cache"
        "${config.settings.server.volumeDirectory}/droppedneedle/plugins:/app/plugins"
        "${config.settings.server.volumeDirectory}/droppedneedle/imports:/app/imports"
        # Keep /data/media/music and slskd completions on one mount boundary.
        "${config.settings.server.containerData}:/data:rw"
      ];
      ports = [ "127.0.0.1:8688:8688" ];

      extraOptions = [
        "--network=arr-net"
        # Run as the host user; the entrypoint skips PUID/PGID setup when non-root.
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-droppedneedle" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."droppedneedle.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8688";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 8g;
        client_body_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
        proxy_request_buffering off;
        proxy_buffering off;
      '';
    };
  };
}
