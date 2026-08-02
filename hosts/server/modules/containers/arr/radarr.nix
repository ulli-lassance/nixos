{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/radarr 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/radarr/config 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerCache}/radarr 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerCache}/radarr/MediaCover 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    radarr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/radarr:latest";

      podman.user = config.settings.user.username;

      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = config.time.timeZone;
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/radarr/config:/config:U"
        "${config.settings.server.containerCache}/radarr/MediaCover:/config/MediaCover:U"
        "${config.settings.user.home}/hd2/movies:/data/movies"
        "${config.settings.user.home}/downloads:/downloads"
      ];
      ports = [ "127.0.0.1:7878:7878" ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-radarr" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."radarr.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:7878";
      proxyWebsockets = true;
    };
  };
}
