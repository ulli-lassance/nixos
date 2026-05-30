{ config, ... }:

{
  virtualisation.oci-containers.containers = {
    feishin = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "ghcr.io/jeffvli/feishin:latest";

      podman.user = config.settings.user.username;

      environment = {
        SERVER_NAME = "nixos server";
        SERVER_LOCK = "true";
        SERVER_TYPE = "navidrome";
        SERVER_URL = "https://navidrome.lan.${config.settings.server.domain}";
        ANALYTICS_DISABLED = "true";
      };

      ports = [ "127.0.0.1:9180:9180" ];

    };
  };

  systemd.services."podman-feishin" = {
    after = [ "podman-network-music-net.service" ];
    requires = [ "podman-network-music-net.service" ];
  };

  services.nginx.virtualHosts."feishin.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9180";
      proxyWebsockets = true;
    };
  };
}
