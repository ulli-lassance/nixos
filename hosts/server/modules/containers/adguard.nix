{
  config,
  lib,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/adguardhome 0755 ${config.settings.user.username} users -"
  ];

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 53;

  services.resolved.settings.Resolve.DNSStubListener = lib.mkForce "no";

  virtualisation.oci-containers.containers."adguardhome" = {
    autoStart = true;
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    image = "docker.io/adguard/adguardhome:latest";

    podman.user = config.settings.user.username;

    volumes = [
      "${config.settings.server.volumeDirectory}/adguardhome/work:/opt/adguardhome/work:U"
      "${config.settings.server.volumeDirectory}/adguardhome/conf:/opt/adguardhome/conf:U"
    ];
    extraOptions = [
      "--network=host"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    53
    3000
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.nginx.virtualHosts."adguard.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    http2 = true;

    locations."/dns-query" = {
      proxyPass = "http://127.0.0.1:3000/dns-query";

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };

    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
  };
}
