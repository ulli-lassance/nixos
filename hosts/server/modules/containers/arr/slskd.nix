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
        SLSKD_DOWNLOADS_DIR = "/soulseek/complete";
        SLSKD_INCOMPLETE_DIR = "/soulseek/incomplete";
        SLSKD_SHARED_DIR = "/music";
        SLSKD_NO_AUTH = "true";
      };
      volumes = [
        "${config.settings.server.volumeDirectory}/slskd:/app:U"
        "${config.settings.server.containerData}/soulseek:/soulseek"
        "${config.settings.server.containerData}/media/music:/music:ro"
      ];
      ports = [
        "127.0.0.1:5030:5030"
        "50300:50300"
      ];

      extraOptions = [
        "--userns=keep-id"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 50300 ];
  networking.firewall.allowedUDPPorts = [ 50300 ];

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
