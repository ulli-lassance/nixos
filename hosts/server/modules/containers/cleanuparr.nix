{ config, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/cleanuparr 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    cleanuparr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/cleanuparr/cleanuparr:latest";

      podman.user = config.settings.user.username;

      environment = {
        PORT = "11011";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/cleanuparr/config:/config:U"
      ];
      ports = [ "127.0.0.1:11011:11011" ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-cleanuparr" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."cleanuparr.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:11011";
      proxyWebsockets = true;
    };
  };
}
