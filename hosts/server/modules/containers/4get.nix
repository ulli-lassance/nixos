{ config, ... }: {
  virtualisation.oci-containers.containers = {
    "4get" = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "docker.io/luuul/4get:latest";

      podman.user = config.settings.user.username;

      environment = {
        FOURGET_SERVER_NAME = "4get.lan.${config.settings.server.domain}";

        FOURGET_PROTO = "http";
      };

      ports = [ "127.0.0.1:9181:80" ];

      volumes = [
        # custom banners
        # "${config.settings.server.volumeDirectory}/4get/banners:/var/www/html/4get/banner"
      ];
    };
  };

  services.nginx.virtualHosts."4get.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9181";
    };
  };
}
