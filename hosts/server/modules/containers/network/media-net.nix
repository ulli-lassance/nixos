{ pkgs, config, ... }:

{
  systemd.services."podman-network-media-net" = {
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
      podman network exists media-net || podman network create media-net
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
