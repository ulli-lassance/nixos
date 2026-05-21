{ config, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/prowlarr 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    prowlarr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/prowlarr:latest";

      podman.user = config.settings.user.username;

      environment = {
        PUID = "1000";
        PGID = "100";
      };

      volumes = [ "${config.settings.server.volumeDirectory}/prowlarr/config:/config:U" ];

      ports = [ "127.0.0.1:9696:9696" ];

      extraOptions = [ 
        "--network=media-net" 
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-prowlarr" = {
    after = [ "podman-network-media-net.service" ];
    requires = [ "podman-network-media-net.service" ];
  };

  services.nginx.virtualHosts."prowlarr.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9696";
      proxyWebsockets = true;
    };
  };
}
