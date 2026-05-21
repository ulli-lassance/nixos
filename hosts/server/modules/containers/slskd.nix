{ config, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/slskd 0755 ${config.settings.user.username} users -"
    
    "d ${config.settings.user.home}/downloads 0755 ${config.settings.user.username} users -"
    "d ${config.settings.user.home}/downloads/slskd 0755 ${config.settings.user.username} users -"
    "d ${config.settings.user.home}/downloads/slskd/incomplete 0755 ${config.settings.user.username} users -"
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
        SLSKD_DOWNLOADS_DIR = "/downloads";
        SLSKD_INCOMPLETE_DIR = "/downloads/slskd/incomplete";
        SLSKD_SHARED_DIR = "/music";
        SLSKD_NO_AUTH = "true";

      };
      volumes = [
        "${config.settings.server.volumeDirectory}/slskd:/app:U"
        "${config.settings.user.home}/downloads:/downloads"
        "${config.settings.user.home}/music:/music"
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

  services.nginx.virtualHosts."soulseek.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5030";
      proxyWebsockets = true;
    };
  };
}
