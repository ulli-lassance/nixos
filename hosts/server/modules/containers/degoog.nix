{ config, ... }: {

  sops.secrets.degoog_settings_passwords = { };

  sops.templates."degoog.env" = {
    owner = config.settings.user.username;
    content = ''
      DEGOOG_SETTINGS_PASSWORDS=${config.sops.placeholder.degoog_settings_passwords}
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/degoog 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/degoog/data 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    "degoog" = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "ghcr.io/degoog-org/degoog:latest";

      podman.user = config.settings.user.username;

      environment = {
        TZ = config.time.timeZone;
        DEGOOG_BASE_URL = "https://degoog.lan.${config.settings.server.domain}";
        DEGOOG_DISTRUST_PROXY = "0";
        DEGOOG_DOCKER = "1";
      };

      environmentFiles = [
        config.sops.templates."degoog.env".path
      ];

      ports = [ "127.0.0.1:4444:4444" ];

      volumes = [
        "${config.settings.server.volumeDirectory}/degoog/data:/app/data"
      ];

      extraOptions = [
        "--userns=keep-id"
        "--network=arr-net" # for flaresolverr things
      ];
    };
  };

  services.nginx.virtualHosts."degoog.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4444";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    };
  };
}
