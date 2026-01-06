{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.system.podman;
in
{
  options.system.podman = {
    enable = lib.mkEnableOption "enables podman and sets it as the oci-container backend";
  };

  config = lib.mkIf cfg.enable {

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;

      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };

    virtualisation.oci-containers.backend = "podman";
  };
}
