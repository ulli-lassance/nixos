{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/lidarr 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/lidarr/config 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerCache}/lidarr 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerCache}/lidarr/MediaCover 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    lidarr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/lidarr:latest";

      podman.user = config.settings.user.username;

      environment = {
        TZ = config.time.timeZone;
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/lidarr/config:/config"
        "${config.settings.server.containerCache}/lidarr/MediaCover:/config/MediaCover"
        "${config.settings.server.containerData}:/data"
      ];
      ports = [ "127.0.0.1:8686:8686" ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-lidarr" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."lidarr.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8686";
      proxyWebsockets = true;
    };
  };
}
