{ config, ... }: {

  sops.secrets.degoog_settings_passwords = { };

  sops.templates."degoog.env" = {
    owner = config.settings.user.username;
    content = ''
      DEGOOG_SETTINGS_PASSWORDS=${config.sops.placeholder.degoog_settings_passwords}
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${config.settings.server.volumeDirectory}/degoog 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.volumeDirectory}/degoog/data 0755 ${config.settings.user.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    "degoog" = {
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };

      image = "ghcr.io/degoog-org/degoog:latest";

      podman.user = config.settings.user.username;

      environment = {
        TZ = config.time.timeZone;
        DEGOOG_BASE_URL = "https://degoog.lan.${config.settings.server.domain}";
        DEGOOG_DISTRUST_PROXY = "0";
        DEGOOG_DOCKER = "1";
      };

      environmentFiles = [
        config.sops.templates."degoog.env".path
      ];

      ports = [ "127.0.0.1:4444:4444" ];

      volumes = [
        "${config.settings.server.volumeDirectory}/degoog/data:/app/data"
      ];

      # bypass the image entrypoint (degoog issue #359): it always runs
      # `chown` + `su-exec`, which cannot work in a rootless podman userns
      # ("chown: /app/data: Operation not permitted" /
      #  "su-exec: setgroups(1000): Operation not permitted").
      # Running `bun` directly means the process is container uid 0, which
      # under the default rootless mapping IS the host user - so data files
      # end up owned by that user on the host, no chown needed.
      entrypoint = "bun";
      cmd = [ "run" "src/server/index.ts" ];
      # NOTE: if a future image update changes the start command, mirror it
      # here (it currently is `bun run src/server/index.ts`).

      extraOptions = [
        # "--userns=keep-id"
      ];
    };
  };

  services.nginx.virtualHosts."degoog.lan.${config.settings.server.domain}" = {
    useACMEHost = config.settings.server.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4444";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    };
  };
}
