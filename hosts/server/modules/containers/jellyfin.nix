{ config, vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/jellyfin 0755 ${vars.username} users -"
    "d ${vars.containerCache}/jellyfin 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    jellyfin = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "docker.io/jellyfin/jellyfin";

      podman.user = vars.username;

      volumes = [
        "${vars.homeDirectory}/hd2/movies:/data/movies"
        "${vars.volumeDirectory}/jellyfin/config:/config:U"
        "${vars.containerCache}/jellyfin:/cache:U"
      ];
      ports = [ "127.0.0.1:8096:8096" ];

      extraOptions = [
        "--device=/dev/dri:/dev/dri"
        "--group-add=${toString config.ids.gids.render}"
        "--network=media-net"
      ];
    };
  };

  systemd.services."podman-jellyfin" = {
    after = [ "podman-network-media-net.service" ];
    requires = [ "podman-network-media-net" ];
  };

  # needed for rootless podman gpu passthru
  users.users."${vars.username}".extraGroups = [
    "render"
    "video"
  ];

  services.nginx.virtualHosts."jellyfin.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_buffering off;
        client_max_body_size 20M;
      '';
    };
  };
}
