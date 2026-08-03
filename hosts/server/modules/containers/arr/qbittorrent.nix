{ config, ... }: {

  sops.secrets.protonvpn_wg_key = {
  };

  sops.templates."gluetun-protonvpn.env" = {
    owner = config.settings.user.username;
    content = ''
      WIREGUARD_PRIVATE_KEY=${config.sops.placeholder.protonvpn_wg_key}
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/qbittorrent 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/qbittorrent/config 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/gluetun 0755 root root -"
    "d ${config.settings.user.home}/downloads 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    gluetun = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "docker.io/qmcgaw/gluetun:latest";
      podman.user = config.settings.user.username;

      ports = [
        "127.0.0.1:8080:8080"
        "6881:6881"
        "6881:6881/udp"
      ];

      environmentFiles = [
        config.sops.templates."gluetun-protonvpn.env".path
      ];

      environment = {
        VPN_SERVICE_PROVIDER = "protonvpn";
        VPN_TYPE = "wireguard";
        SERVER_COUNTRIES = "Brazil";
        PORT_FORWARD_ONLY = "on";
        VPN_PORT_FORWARDING = "on";

        VPN_PORT_FORWARDING_UP_COMMAND = ''
          /bin/sh -c 'until wget -qO- http://127.0.0.1:8080/api/v2/app/version >/dev/null 2>&1; do sleep 2; done; wget -qO- --retry-connrefused --header="Referer: http://127.0.0.1:8080" --post-data "json={\"listen_port\":{{PORT}},\"current_network_interface\":\"{{VPN_INTERFACE}}\",\"random_port\":false,\"upnp\":false}" http://127.0.0.1:8080/api/v2/app/setPreferences'
        '';

        VPN_PORT_FORWARDING_DOWN_COMMAND = ''
          /bin/sh -c 'wget -qO- --retry-connrefused --header="Referer: http://127.0.0.1:8080" --post-data "json={\"listen_port\":0,\"current_network_interface\":\"lo\"}" http://127.0.0.1:8080/api/v2/app/setPreferences'
        '';
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/gluetun:/gluetun"
      ];

      extraOptions = [
        "--cap-add=NET_RAW"
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun:/dev/net/tun"
        "--network=arr-net"
      ];
    };

    qbittorrent = {
      autoStart = true;
      dependsOn = [ "gluetun" ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/qbittorrent:latest";
      podman.user = config.settings.user.username;

      environment = {
        WEBUI_PORT = "8080";
        TORRENTING_PORT = "6881";
        TZ = config.time.timeZone;
        PUID = "1000";
        PGID = "100";
      };
      volumes = [
        "${config.settings.server.volumeDirectory}/qbittorrent/config:/config:U"
        "${config.settings.user.home}/downloads:/downloads"
      ];

      extraOptions = [
        "--network=container:gluetun"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-gluetun" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  systemd.services."podman-qbittorrent" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
    bindsTo = [ "podman-gluetun.service" ];
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
