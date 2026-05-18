{ vars, ... }:

let
  invidiousPort = 3010;
in

{
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
      environment = {
        POSTGRES_DB = "invidious";
        POSTGRES_USER = "kemal";
        POSTGRES_PASSWORD = "kemal";
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
      environment = {
        SERVER_SECRET_KEY = "da0eich2opahWieh";
      };
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
      environment = {
        INVIDIOUS_CONFIG = builtins.toJSON {
          db = {
            dbname = "invidious";
            user = "kemal";
            password = "kemal";
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
          invidious_companion_key = "da0eich2opahWieh";
          hmac_key = "MaeZoerahz5Oosu9";
          domain = "invidious.lan.${vars.domain}";
          external_port = 443;
          https_only = true;
          use_pubsub_feeds = true;
          use_innertube_for_captions = true;
        };
      };
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
    after = [ "podman-network-invidious-net.service" "podman-invidious-db.service" ];
    requires = [ "podman-network-invidious-net.service" ];
  };

  services.nginx.virtualHosts."invidious.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString invidiousPort}";
      proxyWebsockets = true;
    };
  };
}
