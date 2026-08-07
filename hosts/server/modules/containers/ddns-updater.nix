{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/ddns-updater 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/ddns-updater/data 0755 ${config.settings.user.username} users -"
  ];

  sops.secrets.cloudflare_dns = { };

  sops.templates."ddns-updater.env" = {
    owner = config.settings.user.username;
    content =
      let
        configObject = {
          settings = [
            {
              provider = "cloudflare";
              zone_identifier = "960b2eaed430da59562a035a0048b525";
              domain = "vpn.${config.settings.server.domain}";
              ttl = 600;
              token = config.sops.placeholder."cloudflare_dns";
              ip_version = "ipv4";
              ipv6_suffix = "";
            }
          ];
        };
      in
      "CONFIG=${builtins.toJSON configObject}";
  };

  virtualisation.oci-containers.containers."ddns-updater" = {
    autoStart = true;
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    image = "docker.io/qmcgaw/ddns-updater";

    podman.user = config.settings.user.username;

    volumes = [
      "${config.settings.server.volumeDirectory}/ddns-updater/data:/updater/data"
    ];

    extraOptions = [
      "--network=bridge"
      "--userns=keep-id"
    ];
    ports = [ "127.0.0.1:8000:8000" ];

    environmentFiles = [ config.sops.templates."ddns-updater.env".path ];
  };

  services.nginx.virtualHosts."ddns.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8000";
      proxyWebsockets = true;
    };
  };
}
