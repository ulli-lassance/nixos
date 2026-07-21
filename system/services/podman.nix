{
  config,
  lib,
  ...
}:
let
  cfg = config.settings.podman;
in
{
  options.settings.podman = {
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

    # needed for rootless podman
    users.users."${config.settings.user.username}".linger = true;

    virtualisation.oci-containers.backend = "podman";
  };
}
