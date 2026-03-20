{ pkgs, vars, ... }:

{
  systemd.services."podman-network-media-net" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = vars.username;
    };
    environment = {
      HOME = vars.homeDirectory; 
    };
    script = ''
      podman network exists media-net || podman network create media-net
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
