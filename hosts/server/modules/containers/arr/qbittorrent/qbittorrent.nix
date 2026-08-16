{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/qbittorrent 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/qbittorrent/config 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    qbittorrent = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/qbittorrent:latest";

      podman.user = config.settings.user.username;

      environment = {
        WEBUI_PORT = "8081";
        TORRENTING_PORT = "50413";
        TZ = config.time.timeZone;
      };
      volumes = [
        "${config.settings.server.volumeDirectory}/qbittorrent/config:/config"
        "${config.settings.server.containerData}/torrents:/data/torrents"
      ];
      ports = [
        "127.0.0.1:8081:8081"
        "50413:50413"
        "50413:50413/udp"
      ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-qbittorrent" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  networking.firewall.allowedTCPPorts = [ 50413 ];
  networking.firewall.allowedUDPPorts = [ 50413 ];

  services.nginx.virtualHosts."qbit.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8081";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Referer "";
        proxy_set_header Origin "";
      '';
    };
  };
}
