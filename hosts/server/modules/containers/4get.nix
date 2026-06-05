{ config, ... }:

{

  sops.secrets.google_api_key = { };

  sops.templates."google_api.txt" = {
    content = "${config.sops.placeholder.google_api_key}\n";
    owner = config.settings.user.username;
  };

  virtualisation.oci-containers.containers = {

    "4get" = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "docker.io/luuul/4get:latest";

      podman.user = config.settings.user.username;

      environment = {
        FOURGET_SERVER_NAME = "4get.lan.${config.settings.server.domain}";

        FOURGET_PROTO = "http";
      };

      ports = [ "127.0.0.1:9181:80" ];

      volumes = [
        "${config.sops.templates."google_api.txt".path}:/var/www/html/4get/data/api_keys/google_api.txt:ro"
        
        # custom banners
        # "${config.settings.server.volumeDirectory}/4get/banners:/var/www/html/4get/banner:U"
      ];
    };
  };

  services.nginx.virtualHosts."4get.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9181";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
