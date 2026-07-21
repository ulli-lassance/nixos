{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/vaultwarden 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerCache}/vaultwarden 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerCache}/vaultwarden/icon_cache 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerCache}/vaultwarden/tmp 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    vaultwarden = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "docker.io/vaultwarden/server:latest";

      podman.user = config.settings.user.username;

      environment = {
        ROCKET_PORT = "1984";
      };
      volumes = [
        "${config.settings.server.volumeDirectory}/vaultwarden/data:/data:U"
        "${config.settings.server.containerCache}/vaultwarden/icon_cache:/data/icon_cache:U"
        "${config.settings.server.containerCache}/vaultwarden/tmp:/data/tmp:U"
      ];

      ports = [ "127.0.0.1:1984:1984" ];
    };
  };

  services.nginx.virtualHosts."vault.lan.${config.settings.server.domain}" = {
    serverAliases = [ "vault.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:1984";
      proxyWebsockets = true;
    };
  };
}
