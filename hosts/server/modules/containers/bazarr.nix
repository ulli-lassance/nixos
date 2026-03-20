{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/bazarr 0755 ${vars.username} users -"
    "d ${vars.containerCache}/bazarr 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    bazarr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/bazarr:latest";

      podman.user = vars.username;

      environment = {
        PUID = "1000";
        PGID = "100";
      };

      volumes = [
        "${vars.volumeDirectory}/bazarr/config:/config:U"
        "${vars.containerCache}/bazarr:/config/cache:U"
        "${vars.homeDirectory}/hd2/movies:/movies"
        "${vars.homeDirectory}/hd2/series:/series"
      ];
      ports = [ "127.0.0.1:6767:6767" ];

      extraOptions = [ "--network=media-net" ];
    };
  };

  systemd.services."podman-bazarr" = {
    after = [ "podman-network-media-net.service" ];
    requires = [ "podman-network-media-net.service" ];
  };

  services.nginx.virtualHosts."bazarr.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:6767";
      proxyWebsockets = true;
    };
  };
}
