{ config, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/baikal 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/baikal/data 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/baikal/config 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    baikal = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "docker.io/ckulka/baikal:latest";

      podman.user = config.settings.user.username;

      volumes = [
        "${config.settings.server.volumeDirectory}/baikal/data:/var/www/baikal/Specific:U"
        "${config.settings.server.volumeDirectory}/baikal/config:/var/www/baikal/config:U"
      ];

      ports = [ "127.0.0.1:8088:80" ];

    };
  };

  services.nginx.virtualHosts."baikal.lan.${config.settings.server.domain}" = {
    serverAliases = [ "baikal.${config.settings.server.domain}" ];
    
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8088";
    };

    locations."^~ /.well-known/caldav" = {
      return = "301 $scheme://$host/dav.php";
    };

    locations."^~ /.well-known/carddav" = {
      return = "301 $scheme://$host/dav.php";
    };
  };
}
