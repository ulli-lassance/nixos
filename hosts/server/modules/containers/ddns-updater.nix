{ vars, config, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/ddns-updater/data 0755 ${vars.username} users -"
  ];

  sops.secrets.cloudflare_dns = { };

  sops.templates."ddns-updater.env" = {
    content =
      let
        configObject = {
          settings = [
            {
              provider = "cloudflare";
              zone_identifier = "960b2eaed430da59562a035a0048b525";
              domain = "vpn.${vars.domain}";
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
    volumes = [
      "${vars.volumeDirectory}/ddns-updater/data:/updater/data:U"
    ];
    environment = {
      TZ = vars.timezone;
    };
    extraOptions = [
      "--network=bridge"
    ];
    ports = [ "127.0.0.1:8000:8000" ];
    environmentFiles = [ config.sops.templates."ddns-updater.env".path ];
  };

  services.nginx.virtualHosts."ddns.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8000";
      proxyWebsockets = true;
    };
  };
}
