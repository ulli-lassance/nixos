{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/radicale 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/radicale/data 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/radicale/config 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    radicale = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "ghcr.io/kozea/radicale:stable";

      podman.user = config.settings.user.username;

      extraOptions = [
        "--userns=keep-id"
      ];

      volumes = [
        "${config.settings.server.volumeDirectory}/radicale/data:/var/lib/radicale"
        "${config.settings.server.volumeDirectory}/radicale/config:/etc/radicale"
      ];

      ports = [ "127.0.0.1:5232:5232" ];
    };
  };

  services.nginx.virtualHosts."radicale.lan.${config.settings.server.domain}" = {
    serverAliases = [ "radicale.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:5232";
      extraConfig = ''
        proxy_pass_header Authorization;
      '';
    };

    locations."^~ /.well-known/caldav" = {
      return = "301 $scheme://$host/";
    };

    locations."^~ /.well-known/carddav" = {
      return = "301 $scheme://$host/";
    };
  };
}
