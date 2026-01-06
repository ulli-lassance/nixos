{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/qbittorrent 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    qbittorrent = {
      autoStart = true;
      image = "lscr.io/linuxserver/qbittorrent:latest";
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = vars.timezone;
        WEBUI_PORT = "8080";
        TORRENTING_PORT = "6881";
      };
      volumes = [
        "${vars.volumeDirectory}/qbittorrent/config:/config:U"
        "${vars.homeDirectory}/downloads:/downloads"
      ];
      ports = [
        "8080:8080"
        "6881:6881"
        "6881:6881/udp"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    8080
    6881
  ];

  networking.firewall.allowedUDPPorts = [ 6881 ];

  services.nginx.virtualHosts."qbittorrent.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${vars.serverIP}:8080";
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
