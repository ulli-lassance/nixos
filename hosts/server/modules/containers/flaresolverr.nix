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
    };
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
