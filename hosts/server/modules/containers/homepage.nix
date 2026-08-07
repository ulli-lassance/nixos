{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/homepage 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/homepage/config 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    homepage = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "ghcr.io/gethomepage/homepage:latest";

      podman.user = config.settings.user.username;

      environment = {
        TZ = config.time.timeZone;
        PORT = "8082";

        HOMEPAGE_ALLOWED_HOSTS = "homepage.lan.${config.settings.server.domain},homepage.${config.settings.server.domain},127.0.0.1,localhost";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/homepage/config:/app/config:U"
        "/run/user/1000/podman/podman.sock:/var/run/docker.sock:ro"
      ];

      extraOptions = [
        "--userns=keep-id"
        "--network=host"
      ];

    };
  };

  services.nginx.virtualHosts."homepage.lan.${config.settings.server.domain}" = {
    serverAliases = [ "homepage.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8082";
    };
  };
}
