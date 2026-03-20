{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/lidarr 0755 ${vars.username} users -"
    "d ${vars.containerCache}/lidarr/MediaCover 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    lidarr = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "lscr.io/linuxserver/lidarr:latest";

      podman.user = vars.username;

      volumes = [
        "${vars.volumeDirectory}/lidarr/config:/config:U"
        "${vars.containerCache}/lidarr/MediaCover:/config/MediaCover"
        "${vars.homeDirectory}/music:/music"
        "${vars.homeDirectory}/downloads:/downloads"
      ];
      ports = [ "127.0.0.1:8686:8686" ];

      extraOptions = [ "--network=media-net" ];
    };
  };

  systemd.services."podman-lidarr" = {
    after = [ "podman-network-media-net.service" ];
    requires = [ "podman-network-media-net" ];
  };

  services.nginx.virtualHosts."lidarr.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8686";
      proxyWebsockets = true;
    };
  };
}
