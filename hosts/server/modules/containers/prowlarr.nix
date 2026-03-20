{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/prowlarr 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    prowlarr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/prowlarr:latest";

      podman.user = vars.username;

      environment = {
        PUID = "1000";
        PGID = "100";
      };

      volumes = [ "${vars.volumeDirectory}/prowlarr/config:/config:U" ];
      
      ports = [ "127.0.0.1:9696:9696" ];

      extraOptions = [ 
        "--network=media-net" 
        "--userns=keep-id" 
      ];
    };
  };

  systemd.services."podman-prowlarr" = {
    after = [ "podman-network-media-net.service" ];
    requires = [ "podman-network-media-net.service" ];
  };

  services.nginx.virtualHosts."prowlarr.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9696";
      proxyWebsockets = true;
    };
  };
}
