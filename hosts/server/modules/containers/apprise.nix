{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/apprise 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.volumeDirectory}/apprise/config 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/apprise/plugin 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/apprise/attach 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    apprise = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "docker.io/caronc/apprise:latest";

      podman.user = config.settings.user.username;

      environment = {
        APPRISE_STATEFUL_MODE = "simple";
        APPRISE_WORKER_COUNT = "1";
        APPRISE_ADMIN = "y";
        TZ = config.time.timeZone;
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/apprise/config:/config"
        "${config.settings.server.volumeDirectory}/apprise/plugin:/plugin"
        "${config.settings.server.volumeDirectory}/apprise/attach:/attach"
      ];
      ports = [ "127.0.0.1:8100:8000" ];

      extraOptions = [
        "--network=arr-net"
        "--userns=keep-id"
      ];
    };
  };

  services.nginx.virtualHosts."apprise.lan.${config.settings.server.domain}" = {
    serverAliases = [ "apprise.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8100";
      proxyWebsockets = true;
    };
  };
}
