{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/vaultwarden 0755 ${vars.username} users -"
    "d ${vars.containerCache}/vaultwarden/icon_cache 0755 ${vars.username} users -"
    "d ${vars.containerCache}/vaultwarden/tmp 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    vaultwarden = {
      autoStart = true;
      image = "vaultwarden/server:latest";
      environment = {
        ROCKET_PORT = "1984";
      };
      volumes = [
        "${vars.volumeDirectory}/vaultwarden/data:/data:U"
        "${vars.containerCache}/vaultwarden/icon_cache:/data/icon_cache:U"
        "${vars.containerCache}/vaultwarden/tmp:/data/tmp:U"
      ];

      ports = [ "127.0.0.1:1984:1984" ];
    };
  };

  services.nginx.virtualHosts."vault.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:1984";
      proxyWebsockets = true;
    };
  };
}
