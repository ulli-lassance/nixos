{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/slskd-vpn 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/slskd-gluetun 0755 ${config.settings.user.username} users -"
  ];

  sops.secrets.slskd_protonvpn_wg_key = {
  };

  sops.templates."slskd-gluetun-wg-key.env" = {
    owner = config.settings.user.username;
    content = ''
      WIREGUARD_PRIVATE_KEY=${config.sops.placeholder.slskd_protonvpn_wg_key}
    '';
  };

  virtualisation.oci-containers.containers = {
    slskd-gluetun = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "docker.io/qmcgaw/gluetun:latest";
      podman.user = config.settings.user.username;

      ports = [
        "127.0.0.1:5030:5030"
      ];

      environmentFiles = [
        config.sops.templates."slskd-gluetun-wg-key.env".path
      ];

      environment = {
        VPN_SERVICE_PROVIDER = "protonvpn";
        VPN_TYPE = "wireguard";
        SERVER_COUNTRIES = "Uruguay,Brazil,Argentina,Paraguay";
        PORT_FORWARD_ONLY = "on";
        VPN_PORT_FORWARDING = "on";

        HTTP_CONTROL_SERVER_AUTH_DEFAULT_ROLE = ''{"auth":"apikey","apikey":"YourSecretKey123"}'';
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/slskd-gluetun:/gluetun"
      ];

      extraOptions = [
        "--cap-add=NET_RAW"
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun:/dev/net/tun"
      ];
    };

    slskd-vpn = {
      autoStart = true;
      dependsOn = [ "slskd-gluetun" ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "docker.io/slskd/slskd:latest";
      podman.user = config.settings.user.username;

      environment = {
        SLSKD_REMOTE_CONFIGURATION = "true";
        SLSKD_DOWNLOADS_DIR = "/soulseek/complete";
        SLSKD_INCOMPLETE_DIR = "/soulseek/incomplete";
        SLSKD_SHARED_DIR = "/music";
        SLSKD_NO_AUTH = "true";

        SLSKD_VPN = "true";
        SLSKD_VPN_PORT_FORWARDING = "true";
        SLSKD_VPN_GLUETUN_URL = "http://localhost:8000";
        SLSKD_VPN_GLUETUN_API_KEY = "YourSecretKey123";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/slskd-vpn:/app:U"
        "${config.settings.server.containerData}/soulseek:/soulseek"
        "${config.settings.server.containerData}/media/music:/music:ro"
      ];

      extraOptions = [
        "--network=container:slskd-gluetun"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-slskd-gluetun" = {
    partOf = [ "podman-slskd-vpn.service" ];
  };

  systemd.services."podman-slskd-vpn" = {
    after = [ "podman-slskd-gluetun.service" ];
    bindsTo = [ "podman-slskd-gluetun.service" ];
    partOf = [ "podman-slskd-gluetun.service" ];
  };

  services.nginx.virtualHosts."soulseek.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    extraConfig = ''
      client_max_body_size 0;
    '';

    locations."/" = {
      proxyPass = "http://127.0.0.1:5030";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_request_buffering off;
      '';
    };
  };
}
