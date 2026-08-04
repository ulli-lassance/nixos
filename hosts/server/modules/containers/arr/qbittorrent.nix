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
        WEBUI_PORT = "8080";
        TORRENTING_PORT = "6881";
        TZ = config.time.timeZone;
      };
      volumes = [
        "${config.settings.server.volumeDirectory}/qbittorrent/config:/config:U"
        "${config.settings.server.containerData}/torrents:/torrents"
      ];
      ports = [
        "127.0.0.1:8080:8080"
        "6881:6881"
        "6881:6881/udp"
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

  networking.firewall.allowedTCPPorts = [ 6881 ];
  networking.firewall.allowedUDPPorts = [ 6881 ];

  services.nginx.virtualHosts."qbittorrent.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Referer "";
        proxy_set_header Origin "";
      '';
    };
  };
}
