{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/cleanuparr 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    cleanuparr = {
      autoStart = true;
      image = "ghcr.io/cleanuparr/cleanuparr:latest";
      environment = {
        PUID = "1000";
        PGID = "100";
        PORT = "11011";
        TZ = vars.timezone;
      };
      volumes = [
        "${vars.volumeDirectory}/cleanuparr/config:/config:U"
      ];
      ports = [ "127.0.0.1:11011:11011" ];
    };
  };

  services.nginx.virtualHosts."cleanuparr.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:11011";
      proxyWebsockets = true;
    };
  };
}
