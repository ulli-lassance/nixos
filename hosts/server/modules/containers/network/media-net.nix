{ pkgs, ... }:

{
  systemd.services."podman-network-media-net" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman network exists media-net || podman network create media-net
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
