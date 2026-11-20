{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/aurral 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/aurral/config 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/aurral/config/library 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    aurral = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "ghcr.io/lklynet/aurral:latest";

      podman.user = config.settings.user.username;

      environment = {
        TZ = config.time.timeZone;
        AURRAL_PUBLIC_URL = "https://aurral.lan.${config.settings.server.domain}";
        # Keep Aurral's writable Library separate from Lidarr's read-only music.
        LIBRARY_FOLDER = "/config/library";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/aurral/config:/config"
        "${config.settings.server.containerData}:/data:ro"
      ];
      ports = [ "127.0.0.1:3001:3001" ];

      extraOptions = [
        "--network=arr-net"
        # Non-root execution skips the image entrypoint's chown/setpriv steps.
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-aurral" = {
    after = [ "podman-network-arr-net.service" ];
    requires = [ "podman-network-arr-net.service" ];
  };

  services.nginx.virtualHosts."aurral.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3001";
      proxyWebsockets = true;
    };
  };
}
