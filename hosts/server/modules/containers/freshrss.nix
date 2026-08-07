{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/freshrss 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/freshrss/data 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/freshrss/extensions 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    freshrss = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "docker.io/freshrss/freshrss:latest";

      podman.user = config.settings.user.username;

      environment = {
        TZ = config.time.timeZone;
        CRON_MIN = "2,32";
        TRUSTED_PROXY = "127.0.0.1/8 172.16.0.0/12 192.168.0.0/16 10.0.0.0/8";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/freshrss/data:/var/www/FreshRSS/data"
        "${config.settings.server.volumeDirectory}/freshrss/extensions:/var/www/FreshRSS/extensions"
      ];

      ports = [ "127.0.0.1:8089:80" ];
    };
  };

  services.nginx.virtualHosts."freshrss.lan.${config.settings.server.domain}" = {
    serverAliases = [ "freshrss.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8089";
    };
  };
}
