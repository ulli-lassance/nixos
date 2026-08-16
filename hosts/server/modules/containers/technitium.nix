{
  config,
  lib,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/technitium 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/technitium/config 0755 ${config.settings.user.username} users -"
  ];

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 53;

  services.resolved.settings.Resolve.DNSStubListener = lib.mkForce "no";

  virtualisation.oci-containers.containers."technitium" = {
    autoStart = true;
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    image = "docker.io/technitium/dns-server:latest";

    podman.user = config.settings.user.username;

    ports = [
      "53:53/tcp"
      "53:53/udp"
      "127.0.0.1:5380:5380/tcp"
      "127.0.0.1:8053:80/tcp"
    ];

    # if i plan to use dhcp server
    # extraOptions = [
    #   "--network=host"
    #   "--cap-add=NET_RAW"
    # ];

    volumes = [
      "${config.settings.server.volumeDirectory}/technitium/config:/etc/dns"
    ];

    environment = {
      TZ = config.time.timeZone;
      DNS_SERVER_DOMAIN = "technitium-dns-server";
      DNS_SERVER_OPTIONAL_PROTOCOL_DNS_OVER_HTTP = "true";
      DNS_SERVER_WEB_SERVICE_HTTP_PORT = "5380";

    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.nginx.virtualHosts."technitium.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    http2 = true;

    locations."/dns-query" = {
      proxyPass = "http://127.0.0.1:8053/dns-query";

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };

    locations."/" = {
      proxyPass = "http://127.0.0.1:5380";
      proxyWebsockets = true;
    };
  };
}
