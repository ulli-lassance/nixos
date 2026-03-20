{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/cleanuparr 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    cleanuparr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/cleanuparr/cleanuparr:latest";

      podman.user = vars.username;

      environment = {
        PORT = "11011";
      };

      volumes = [
        "${vars.volumeDirectory}/cleanuparr/config:/config:U"
      ];
      ports = [ "127.0.0.1:11011:11011" ];

      extraOptions = [ "--network=media-net" ];
    };
  };

  systemd.services."podman-cleanuparr" = {
    after = [ "podman-network-media-net.service" ];
    requires = [ "podman-network-media-net" ];
  };

  services.nginx.virtualHosts."cleanuparr.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:11011";
      proxyWebsockets = true;
    };
  };
}
