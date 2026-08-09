{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/thelounge 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/thelounge/data 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    thelounge = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/thelounge/thelounge:latest";

      podman.user = config.settings.user.username;

      volumes = [
        "${config.settings.server.volumeDirectory}/thelounge/data:/var/opt/thelounge"
      ];

      ports = [ "127.0.0.1:9000:9000" ];

      extraOptions = [
        "--userns=keep-id"
      ];
    };
  };

  services.nginx.virtualHosts."thelounge.lan.${config.settings.server.domain}" = {
    serverAliases = [ "thelounge.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9000";
    };
  };
}
