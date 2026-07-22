{
  pkgs,
  config,
  ...
}:
{
  systemd.services."podman-network-arr-net" = {
    path = [
      pkgs.podman
      "/run/wrappers"
    ];

    after = [ "user@${toString config.users.users.${config.settings.user.username}.uid}.service" ];
    requires = [ "user@${toString config.users.users.${config.settings.user.username}.uid}.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = config.settings.user.username;
    };
    environment = {
      HOME = config.settings.user.home;
      XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.${config.settings.user.username}.uid}";
    };
    script = ''
      podman network exists arr-net || podman network create arr-net
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
