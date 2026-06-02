{ config, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/bazarr 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerCache}/bazarr 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    bazarr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/bazarr:latest";

      podman.user = config.settings.user.username;

      environment = {
        PUID = "1000";
        PGID = "100";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/bazarr/config:/config:U"
        "${config.settings.server.containerCache}/bazarr:/config/cache:U"
        "${config.settings.user.home}/hd2/movies:/movies"
        "${config.settings.user.home}/hd2/series:/series"
      ];
      ports = [ "127.0.0.1:6767:6767" ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-bazarr" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."bazarr.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:6767";
      proxyWebsockets = true;
    };
  };
}
