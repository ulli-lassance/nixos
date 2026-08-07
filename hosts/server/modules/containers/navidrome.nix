{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/navidrome 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/navidrome/data 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerCache}/navidrome 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    navidrome = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "docker.io/deluan/navidrome:latest";

      podman.user = config.settings.user.username;

      environment = {
        ND_SCANSCHEDULE = "1h";
        ND_PORT = "4533";
        ND_TRANSCODINGCACHESIZE = "500MB";
        ND_IMAGECACHESIZE = "200MB";
      };
      volumes = [
        "${config.settings.server.containerData}/media/music:/music:ro"
        "${config.settings.server.volumeDirectory}/navidrome/data:/data"
        "${config.settings.server.containerCache}/navidrome:/data/cache"
      ];
      ports = [ "127.0.0.1:4533:4533" ];

      extraOptions = [
        "--userns=keep-id"
      ];
    };
  };

  services.nginx.virtualHosts."navidrome.lan.${config.settings.server.domain}" = {
    serverAliases = [ "navidrome.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4533";
      proxyWebsockets = true;
    };
  };
}
