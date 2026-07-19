{ config, ... }:

{
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
          "navidrome.${config.settings.server.domain}" =
            "http://127.0.0.1:4533";

        };
      };
    };
  };
}
