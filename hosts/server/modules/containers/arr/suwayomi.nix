{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/suwayomi 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/suwayomi/data 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerCache}/suwayomi 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerCache}/suwayomi/cache 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    suwayomi = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/suwayomi/suwayomi-server:preview";

      podman.user = config.settings.user.username;

      environment = {
        "TZ" = "Etc/UTC";
        "DOWNLOAD_AS_CBZ" = "true";
        "FLARESOLVERR_ENABLED" = "true";
        "FLARESOLVERR_URL" = "http://flaresolverr:8191";
      };

      volumes = [
        "${config.settings.server.containerData}/media/manga:/home/suwayomi/.local/share/Tachidesk/downloads"
        "${config.settings.server.volumeDirectory}/suwayomi/data:/home/suwayomi/.local/share/Tachidesk"
        "${config.settings.server.containerCache}/suwayomi/cache:/home/suwayomi/.local/share/Tachidesk/cache"
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

  systemd.services."podman-suwayomi" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
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
