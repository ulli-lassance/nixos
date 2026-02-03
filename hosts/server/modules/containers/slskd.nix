{ vars, ... }:

{
  systemd.tmpfiles.rules = [
    "d ${vars.volumeDirectory}/slskd 0755 ${vars.username} users -"
    "d ${vars.homeDirectory}/downloads 0755 ${vars.username} users -"
    "d ${vars.homeDirectory}/downloads/slskd 0755 ${vars.username} users -"
    "d ${vars.homeDirectory}/downloads/slskd/incomplete 0755 ${vars.username} users -"
  ];

  virtualisation.oci-containers.containers = {
    slskd = {
      autoStart = true;
      image = "slskd/slskd:latest";
      environment = {
        SLSKD_REMOTE_CONFIGURATION = "true";
        SLSKD_DOWNLOADS_DIR = "/downloads";
        SLSKD_INCOMPLETE_DIR = "/downloads/slskd/incomplete";
        SLSKD_SHARED_DIR = "/music";
        SLSKD_NO_AUTH = "true";

      };
      volumes = [
        "${vars.volumeDirectory}/slskd:/app:U"
        "${vars.homeDirectory}/downloads:/downloads"
        "${vars.homeDirectory}/music:/music"
      ];
      ports = [
        "127.0.0.1:5030:5030"
        "50300:50300"
      ];
    };
  };

  services.nginx.virtualHosts."soulseek.lan.${vars.domain}" = {
    useACMEHost = vars.domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5030";
      proxyWebsockets = true;
    };
  };
}
