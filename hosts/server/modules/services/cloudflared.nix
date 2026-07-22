{ config, ... }: {
  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = { };

  sops.secrets."cloudflared_credentials" = {
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0440";
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "50c42027-0c5e-4f46-a660-58b37058c543" = {
        credentialsFile = config.sops.secrets."cloudflared_credentials".path;
        default = "http_status:404";

        ingress = {
          "navidrome.${config.settings.server.domain}" = {
            service = "https://127.0.0.1:443";
            originRequest = {
              originServerName = "navidrome.lan.${config.settings.server.domain}";
              noTLSVerify = true;
            };
          };

          "jellyfin.${config.settings.server.domain}" = {
            service = "https://127.0.0.1:443";
            originRequest = {
              originServerName = "jellyfin.lan.${config.settings.server.domain}";
              noTLSVerify = true;
            };
          };

          "vault.${config.settings.server.domain}" = {
            service = "https://127.0.0.1:443";
            originRequest = {
              originServerName = "vault.lan.${config.settings.server.domain}";
              noTLSVerify = true;
            };
          };

          "baikal.${config.settings.server.domain}" = {
            service = "https://127.0.0.1:443";
            originRequest = {
              originServerName = "baikal.lan.${config.settings.server.domain}";
              noTLSVerify = true;
            };
          };

          "immich.${config.settings.server.domain}" = {
            service = "https://127.0.0.1:443";
            originRequest = {
              originServerName = "immich.lan.${config.settings.server.domain}";
              noTLSVerify = true;
            };
          };
        };
      };
    };
  };
}
