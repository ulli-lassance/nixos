{ config, ... }: {

  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/slskd 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    slskd = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "docker.io/slskd/slskd:latest";

      podman.user = config.settings.user.username;

      environment = {
        SLSKD_REMOTE_CONFIGURATION = "true";
        SLSKD_DOWNLOADS_DIR = "/data/soulseek/complete";
        SLSKD_INCOMPLETE_DIR = "/data/soulseek/incomplete";
        SLSKD_SHARED_DIR = "/data/media/music";
        SLSKD_NO_AUTH = "true";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/slskd-vpn:/app"
        "${config.settings.server.containerData}/soulseek:/data/soulseek"
        "${config.settings.server.containerData}/media/music:/data/media/music:ro"
      ];

      ports = [
        "127.0.0.1:5030:5030"
        "50300:50300"
      ];

      extraOptions = [
        "--userns=keep-id"
        "--network=arr-net"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 50300 ];
  networking.firewall.allowedUDPPorts = [ 50300 ];

  services.nginx.virtualHosts."slskd.lan.${config.settings.server.domain}" = {
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
