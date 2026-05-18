{ config, vars, ... }:

let
  invidiousPort = 3010;
in
{
  sops.secrets."invidious/companion_key" = { };
  sops.secrets."invidious/hmac_key" = { };
  sops.secrets."invidious/db_password" = { };

  sops.templates."invidious-db.env" = {
    owner = vars.username;
    content = ''
      POSTGRES_PASSWORD=${config.sops.placeholder."invidious/db_password"}
    '';
  };

  sops.templates."invidious-companion.env" = {
    owner = vars.username;
    content = ''
      SERVER_SECRET_KEY=${config.sops.placeholder."invidious/companion_key"}
    '';
  };

  sops.templates."invidious.env" = {
    owner = vars.username;
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
          domain = "invidious.lan.${vars.domain}";
          external_port = 443;
          https_only = true;
          use_pubsub_feeds = true;
          use_innertube_for_captions = true;
        }
      }
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/invidious 0755 ${vars.username} users -"
    "d ${vars.volumeDirectory}/invidious/postgres 0755 ${vars.username} users -"
    "d ${vars.volumeDirectory}/invidious/data 0755 ${vars.username} users -"

    "d ${vars.containerCache}/invidious 0755 ${vars.username} users -"
    "d ${vars.containerCache}/invidious/companion 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    invidious-db = {
      autoStart = true;
      image = "docker.io/library/postgres:14";
      podman.user = vars.username;

      environmentFiles = [ config.sops.templates."invidious-db.env".path ];

      environment = {
        POSTGRES_DB = "invidious";
        POSTGRES_USER = "kemal";
      };

      volumes = [
        "${vars.volumeDirectory}/invidious/postgres:/var/lib/postgresql/data:U"
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
      podman.user = vars.username;

      environmentFiles = [ config.sops.templates."invidious-companion.env".path ];

      volumes = [
        "${vars.containerCache}/invidious/companion:/var/tmp/youtubei.js:U"
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
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "quay.io/invidious/invidious:latest";
      podman.user = vars.username;

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

  systemd.services."podman-invidious" = {
    after = [
      "podman-network-invidious-net.service"
      "podman-invidious-db.service"
    ];
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

  services.nginx.virtualHosts."invidious.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
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
