{ config, pkgs, ... }:
let
  immichPort = 2283;
  dbUser = "immich";
  dbName = "immich";
in
{
  sops.secrets."immich/db_password" = { };

  sops.templates."immich-db.env" = {
    owner = config.settings.user.username;
    content = ''
      POSTGRES_PASSWORD=${config.sops.placeholder."immich/db_password"}
    '';
  };

  sops.templates."immich-server.env" = {
    owner = config.settings.user.username;
    content = ''
      DB_PASSWORD=${config.sops.placeholder."immich/db_password"}
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/immich 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/immich/postgres 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/immich/valkey 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerCache}/immich 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerCache}/immich/machine-learning 0755 ${config.settings.user.username} users -"

    "d ${config.settings.user.home}/hd2/immich 0755 ${config.settings.user.username} users -"
  ];

  systemd.services."podman-network-immich-net" = {
    path = [
      pkgs.podman
      "/run/wrappers"
    ];

    after = [ "user@1000.service" ];
    requires = [ "user@1000.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = config.settings.user.username;
    };
    environment = {
      HOME = config.settings.user.home;
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
    script = ''
      podman network exists immich-net || podman network create immich-net
    '';
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation.oci-containers.containers = {
    immich-postgres = {
      autoStart = true;
      image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
      podman.user = config.settings.user.username;

      environmentFiles = [ config.sops.templates."immich-db.env".path ];

      environment = {
        POSTGRES_USER = dbUser;
        POSTGRES_DB = dbName;
        POSTGRES_INITDB_ARGS = "--data-checksums";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/immich/postgres:/var/lib/postgresql/data:U"
      ];

      extraOptions = [
        "--network=immich-net"
        "--userns=keep-id"
        "--shm-size=128mb"
      ];
    };

    immich-valkey = {
      autoStart = true;
      image = "docker.io/valkey/valkey:9@sha256:4963247afc4cd33c7d3b2d2816b9f7f8eeebab148d29056c2ca4d7cbc966f2d9";
      podman.user = config.settings.user.username;

      volumes = [
        "${config.settings.server.volumeDirectory}/immich/valkey:/data:U"
      ];

      extraOptions = [
        "--network=immich-net"
        "--userns=keep-id"
      ];
    };

    immich-machine-learning = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "ghcr.io/immich-app/immich-machine-learning:release-openvino";
      podman.user = config.settings.user.username;

      volumes = [
        "${config.settings.server.containerCache}/immich/machine-learning:/cache:U"
      ];

      extraOptions = [
        "--network=immich-net"
        "--device=/dev/dri:/dev/dri"
        "--group-add=${toString config.ids.gids.render}"
        "--userns=keep-id"
      ];
    };

    immich-server = {
      autoStart = true;
      dependsOn = [
        "immich-postgres"
        "immich-valkey"
        "immich-machine-learning"
      ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "ghcr.io/immich-app/immich-server:release";
      podman.user = config.settings.user.username;

      environmentFiles = [ config.sops.templates."immich-server.env".path ];

      environment = {
        DB_HOSTNAME = "immich-postgres";
        DB_USERNAME = dbUser;
        DB_DATABASE_NAME = dbName;
        REDIS_HOSTNAME = "immich-valkey";
        IMMICH_MACHINE_LEARNING_URL = "http://immich-machine-learning:3003";
      };

      volumes = [
        "${config.settings.user.home}/hd2/immich:/data:U"
        "/etc/localtime:/etc/localtime:ro"
      ];

      ports = [ "127.0.0.1:${toString immichPort}:${toString immichPort}" ];

      extraOptions = [
        "--network=immich-net"
        "--device=/dev/dri:/dev/dri"
        "--group-add=${toString config.ids.gids.render}"
        "--userns=keep-id"
      ];
    };
  };

  systemd.services."podman-immich-postgres" = {
    after = [ "podman-network-immich-net.service" ];
    requires = [ "podman-network-immich-net.service" ];
  };

  systemd.services."podman-immich-valkey" = {
    after = [ "podman-network-immich-net.service" ];
    requires = [ "podman-network-immich-net.service" ];
  };

  systemd.services."podman-immich-machine-learning" = {
    after = [ "podman-network-immich-net.service" ];
    requires = [ "podman-network-immich-net.service" ];
  };

  systemd.services."podman-immich-server" = {
    after = [ "podman-network-immich-net.service" ];
    requires = [ "podman-network-immich-net.service" ];
  };

  users.users."${config.settings.user.username}".extraGroups = [
    "render"
    "video"
  ];

  services.nginx.virtualHosts."immich.lan.${config.settings.server.domain}" = {
    serverAliases = [ "immich.${config.settings.server.domain}" ];

    useACMEHost = config.settings.server.domain;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString immichPort}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_buffering off;
        client_max_body_size 50000M;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };
}
