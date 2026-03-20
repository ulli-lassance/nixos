{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/qbittorrent 0755 ${vars.username} users -"
    "d ${vars.homeDirectory}/downloads 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    qbittorrent = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/qbittorrent:latest";

      podman.user = vars.username;
      
      environment = {
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

      extraOptions = [ "--network=media-net" ];
      dependsOn = [ "podman-network-media-net" ];
    };
  };

  systemd.services."podman-qbittorrent".after = [ "podman-network-media-net.service" ];

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
