{ pkgs, vars, ... }:

{
  systemd.services."podman-network-invidious-net" = {
    path = [
      pkgs.podman
      "/run/wrappers"
    ];

    after = [ "user@1000.service" ];
    requires = [ "user@1000.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = vars.username;
    };
    environment = {
      HOME = vars.homeDirectory;
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
    script = ''
      podman network exists invidious-net || podman network create invidious-net
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
