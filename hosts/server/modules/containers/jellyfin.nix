{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/jellyfin 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/jellyfin/config 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerCache}/jellyfin 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    jellyfin = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "docker.io/jellyfin/jellyfin";

      podman.user = config.settings.user.username;

      volumes = [
        "${config.settings.user.home}/hd2/movies:/data/movies"
        "${config.settings.user.home}/hd2/series:/data/series"
        "${config.settings.server.volumeDirectory}/jellyfin/config:/config:U"
        "${config.settings.server.containerCache}/jellyfin:/cache:U"
      ];
      ports = [ "127.0.0.1:8096:8096" ];

      extraOptions = [
        "--device=/dev/dri:/dev/dri"
        "--group-add=${toString config.ids.gids.render}"
        "--userns=keep-id"
      ];
    };
  };

  # needed for rootless podman gpu passthru
  users.users."${config.settings.user.username}".extraGroups = [
    "render"
    "video"
  ];

  services.nginx.virtualHosts."jellyfin.lan.${config.settings.server.domain}" = {
    serverAliases = [ "jellyfin.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_buffering off;
        client_max_body_size 20M;
        proxy_set_header X-Forwarded-Protocol $scheme;
      '';
    };

    locations."/socket" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header X-Forwarded-Protocol $scheme;
      '';
    };
  };
}
