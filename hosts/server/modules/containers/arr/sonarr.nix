{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/sonarr 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/sonarr/config 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerCache}/sonarr 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerCache}/sonarr/MediaCover 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    sonarr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/sonarr:latest";

      podman.user = config.settings.user.username;

      environment = {
        TZ = config.time.timeZone;
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/sonarr/config:/config"
        "${config.settings.server.containerCache}/sonarr/MediaCover:/config/MediaCover"
        "${config.settings.server.containerData}:/data"
      ];
      ports = [ "127.0.0.1:8989:8989" ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-sonarr" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."sonarr.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8989";
      proxyWebsockets = true;
    };
  };
}
