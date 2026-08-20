{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/suwayomi 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/suwayomi/downloads 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/suwayomi/data 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    suwayomi = {
      autoStart = true;
      image = "ghcr.io/suwayomi/suwayomi-server:preview";

      podman.user = config.settings.user.username;

      environment = {
        "TZ" = "Etc/UTC";
        "FLARESOLVERR_ENABLED" = "true";
        "FLARESOLVERR_URL" = "http://flaresolverr:8191";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/suwayomi/downloads:/home/suwayomi/.local/share/Tachidesk/downloads"
        "${config.settings.server.volumeDirectory}/suwayomi/data:/home/suwayomi/.local/share/Tachidesk"
      ];

      ports = [
        "127.0.0.1:4567:4567"
      ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"
      ];
    };
  };

  services.nginx.virtualHosts."suwayomi.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4567";
      proxyWebsockets = true;
    };
  };
}