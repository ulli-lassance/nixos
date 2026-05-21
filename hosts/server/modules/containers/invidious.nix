{ config, ... }:

let
  invidiousPort = 3010;
in
{
  sops.secrets."invidious/companion_key" = { };
  sops.secrets."invidious/hmac_key" = { };
  sops.secrets."invidious/db_password" = { };

  sops.templates."invidious-db.env" = {
    owner = config.settings.user.username;
    content = ''
      POSTGRES_PASSWORD=${config.sops.placeholder."invidious/db_password"}
    '';
  };

  sops.templates."invidious-companion.env" = {
    owner = config.settings.user.username;
    content = ''
      SERVER_SECRET_KEY=${config.sops.placeholder."invidious/companion_key"}
    '';
  };

  sops.templates."invidious.env" = {
    owner = config.settings.user.username;
    content = ''
      INVIDIOUS_CONFIG=${
        builtins.toJSON {
          db = {
            dbname = "invidious";
            user = "kemal";
            password = config.sops.placeholder."invidious/db_password";
            host = "invidious-db";
            port = 5432;
          };
          port = invidiousPort;
          check_tables = true;
          invidious_companion = [
            {
              private_url = "http://invidious-companion:8282/companion";
            }
          ];
          invidious_companion_key = config.sops.placeholder."invidious/companion_key";
          hmac_key = config.sops.placeholder."invidious/hmac_key";
          domain = "invidious.lan.${config.settings.server.domain}";
          external_port = 443;
          https_only = true;
          use_pubsub_feeds = true;
          use_innertube_for_captions = true;
        }
      }
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/invidious 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/invidious/postgres 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerCache}/invidious 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerCache}/invidious/companion 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    invidious-db = {
      autoStart = true;
      image = "docker.io/library/postgres:14";
      podman.user = config.settings.user.username;

      environmentFiles = [ config.sops.templates."invidious-db.env".path ];

      environment = {
        POSTGRES_DB = "invidious";
        POSTGRES_USER = "kemal";
      };

      volumes = [
        "${config.settings.server.volumeDirectory}/invidious/postgres:/var/lib/postgresql/data"
        "${config.settings.server.volumeDirectory}/invidious/sql:/config/sql"
        "${config.settings.server.volumeDirectory}/invidious/init-invidious-db.sh:/docker-entrypoint-initdb.d/init-invidious-db.sh"
        
      ];
      extraOptions = [
        "--network=invidious-net"
        "--health-cmd=pg_isready -U kemal -d invidious"
        "--health-interval=30s"
        "--health-timeout=5s"
        "--health-retries=3"
      ];
    };

    invidious-companion = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "quay.io/invidious/invidious-companion:latest";
      podman.user = config.settings.user.username;

      environmentFiles = [ config.sops.templates."invidious-companion.env".path ];

      volumes = [
        "${config.settings.server.containerCache}/invidious/companion:/var/tmp/youtubei.js:rw"
      ];
      extraOptions = [
        "--network=invidious-net"
        "--cap-drop=ALL"
        "--read-only"
        "--security-opt=no-new-privileges:true"
      ];
    };

    invidious = {
      autoStart = true;
      dependsOn = [ "invidious-db" "invidious-companion" ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "quay.io/invidious/invidious:latest";
      podman.user = config.settings.user.username;

      environmentFiles = [ config.sops.templates."invidious.env".path ];

      ports = [ "127.0.0.1:${toString invidiousPort}:${toString invidiousPort}" ];
      extraOptions = [
        "--network=invidious-net"
        "--health-cmd=wget -nv --tries=1 --spider http://127.0.0.1:${toString invidiousPort}/api/v1/stats || exit 1"
        "--health-interval=30s"
        "--health-timeout=5s"
        "--health-retries=2"
      ];
    };
  };

  systemd.services."podman-invidious-db" = {
    after = [ "podman-network-invidious-net.service" ];
    requires = [ "podman-network-invidious-net.service" ];
  };

  systemd.services."podman-invidious-companion" = {
    after = [ "podman-network-invidious-net.service" ];
    requires = [ "podman-network-invidious-net.service" ];
  };


  systemd.services."restart-invidious" = {
    description = "periodic restart of Invidious";
    after = [ "podman-invidious.service" ];
    script = ''
      echo "triggering scheduled restart of podman-invidious.service..."

      if systemctl restart podman-invidious.service; then
        echo "successfully restarted podman-invidious.service."
      else
        echo "FAILED to restart podman-invidious.service!" >&2
        exit 1
      fi
    '';
    serviceConfig.Type = "oneshot";
  };

  systemd.timers."restart-invidious" = {
    description = "hourly restart timer for Invidious";
    timerConfig = {
      OnCalendar = "hourly";
      RandomizedDelaySec = "5min";
    };
    wantedBy = [ "timers.target" ];
  };

  services.nginx.virtualHosts."invidious.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString invidiousPort}";
      extraConfig = ''
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
      '';
    };
  };
}
