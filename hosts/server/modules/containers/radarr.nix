{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/radarr 0755 ${vars.username} users -"
    "d ${vars.containerCache}/radarr/MediaCover 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    radarr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/radarr:latest";

      podman.user = vars.username;
      
      volumes = [
        "${vars.volumeDirectory}/radarr/config:/config:U"
        "${vars.containerCache}/radarr/MediaCover:/config/MediaCover:U"
        "${vars.homeDirectory}/hd2/movies:/data/movies"
        "${vars.homeDirectory}/downloads:/downloads"
      ];
      ports = [ "127.0.0.1:7878:7878" ];

      extraOptions = [ "--network=media-net" ];
      dependsOn = [ "podman-network-media-net" ];
    };
  };

  systemd.services."podman-radarr".after = [ "podman-network-media-net.service" ];

  services.nginx.virtualHosts."radarr.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:7878";
      proxyWebsockets = true;
    };
  };
}
