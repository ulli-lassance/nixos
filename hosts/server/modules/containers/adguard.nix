{ vars, lib, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/adguardhome 0755 ${vars.username} users -"
  ];

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 53;

  services.resolved.settings.Resolve.DNSStubListener = lib.mkForce "no";

  virtualisation.oci-containers.containers."adguardhome" = {
    autoStart = true;
    labels = {
        "io.containers.autoupdate" = "registry";
      };
    image = "docker.io/adguard/adguardhome:latest";

    podman.user = vars.username;

    volumes = [
      "${vars.volumeDirectory}/adguardhome/work:/opt/adguardhome/work:U"
      "${vars.volumeDirectory}/adguardhome/conf:/opt/adguardhome/conf:U"
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

  services.nginx.virtualHosts."adguard.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
  };
}
