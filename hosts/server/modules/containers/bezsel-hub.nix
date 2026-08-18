{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/beszel 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/beszel/data 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    beszel-hub = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "docker.io/henrygd/beszel:latest";

      podman.user = config.settings.user.username;

      ports = [
        "127.0.0.1:8090:8090"
      ];

      environment = {
        TZ = config.time.timeZone;
        APP_URL = "https://beszel.lan.${config.settings.server.domain}";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/beszel/data:/beszel_data"
      ];

    };

  };

  services.nginx.virtualHosts."beszel.lan.${config.settings.server.domain}" = {
    serverAliases = [ "beszel.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;

    locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:8090";
      extraConfig = ''
        proxy_read_timeout 360s;
        client_max_body_size 10M;
      '';
    };
  };
}
