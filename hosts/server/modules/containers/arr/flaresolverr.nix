{ config, ... }: {
  virtualisation.oci-containers.containers = {
    flaresolverr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/flaresolverr/flaresolverr:latest";

      podman.user = config.settings.user.username;

      ports = [ "127.0.0.1:8191:8191" ];

      extraOptions = [ "--network=arr-net" ];
    };
  };

  systemd.services."podman-flaresolverr" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."flaresolverr.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8191";
    };
  };
}
