{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/seerr 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/seerr/config 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    seerr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/seerr-team/seerr:latest";

      podman.user = config.settings.user.username;

      environment = {
        LOG_LEVEL = "debug";
        TZ = config.time.timeZone;
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/seerr/config:/app/config:U"
      ];
      ports = [ "127.0.0.1:5055:5055" ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"

        "--init"

        # healthcheck
        "--health-cmd=wget --no-verbose --tries=1 --spider http://localhost:5055/api/v1/settings/public || exit 1"
        "--health-start-period=20s"
        "--health-timeout=3s"
        "--health-interval=15s"
        "--health-retries=3"
      ];
    };
  };

  systemd.services."podman-seerr" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."seerr.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5055";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Referer $http_referer;
        proxy_set_header X-Real-Port $remote_port;
        proxy_set_header X-Forwarded-Port $remote_port;
        proxy_set_header X-Forwarded-Ssl on;

        proxy_set_header X-Forwarded-Host $host:$remote_port;
      '';
    };
  };
}
