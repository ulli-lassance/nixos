{ vars, ... }:

{
  virtualisation.oci-containers.containers = {
    flaresolverr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/flaresolverr/flaresolverr:latest";

      podman.user = vars.username;

      ports = [ "127.0.0.1:8191:8191" ];

      extraOptions = [ "--network=media-net" ];
    };
  };

  systemd.services."podman-flaresolverr" = {
    after = [ "podman-network-media-net.service" ];
    requires = [ "podman-network-media-net.service" ];
  };

  services.nginx.virtualHosts."flaresolverr.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8191";
      proxyWebsockets = true;
    };
  };
}
