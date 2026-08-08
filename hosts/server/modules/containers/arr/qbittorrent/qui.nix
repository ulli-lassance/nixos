{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/qui 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/qui/config 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    qui = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/autobrr/qui:latest";

      podman.user = config.settings.user.username;

      volumes = [
        "${config.settings.server.volumeDirectory}/qui/config:/config"
      ];
      ports = [
        "127.0.0.1:7476:7476"
      ];

      extraOptions = [
        "--network=arr-net"
      ];
    };
  };

  systemd.services."podman-qui" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."qui.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:7476";
      proxyWebsockets = true;
    };
  };
}
