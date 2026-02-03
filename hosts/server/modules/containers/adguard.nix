{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/adguardhome 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers."adguardhome" = {
    autoStart = true;
    labels = {
        "io.containers.autoupdate" = "registry";
      };
    image = "docker.io/adguard/adguardhome:latest";
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "3000:3000/tcp"
    ];
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
