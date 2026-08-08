{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/autobrr 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/autobrr/config 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    autobrr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/autobrr/autobrr:latest";

      podman.user = config.settings.user.username;

      volumes = [
        "${config.settings.server.volumeDirectory}/autobrr/config:/config"
      ];
      ports = [
        "127.0.0.1:7474:7474"
      ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-autobrr" = {
    after = [ "podman-network-arr-net.service" ];
    reautobrrres = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."autobrr.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:7474";
      proxyWebsockets = true;
    };
  };
}
