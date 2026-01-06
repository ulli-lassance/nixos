{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/navidrome 0755 ${vars.username} users -"
    "d ${vars.containerCache}/navidrome 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    navidrome = {
      autoStart = true;
      image = "deluan/navidrome:latest";
      environment = {
        ND_SCANSCHEDULE = "1h";
        ND_PORT = "4533";
        ND_TRANSCODINGCACHESIZE = "500MB";
        ND_IMAGECACHESIZE = "200MB";
      };
      volumes = [
        "${vars.homeDirectory}/music:/music"
        "${vars.volumeDirectory}/navidrome/data:/data:U"
        "${vars.containerCache}/navidrome:/data/cache:U"
      ];
      ports = [ "127.0.0.1:4533:4533" ];
    };
  };

  services.nginx.virtualHosts."navidrome.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4533";
      proxyWebsockets = true;
    };
  };
}
