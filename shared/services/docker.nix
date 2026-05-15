{
  config,
  pkgs,
  vars,
  lib,
  ...
}:

let
  cfg = config.system.docker;
in
{
  options.system.docker = {
    enable = lib.mkEnableOption "enables docker, adds user to the docker group and sets it as the oci-container backend";
  };

  config = lib.mkIf cfg.enable {

    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;

      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };

    environment.systemPackages = [ pkgs.docker-compose ];

    users.users."${vars.username}".extraGroups = [ "docker" ];

    virtualisation.oci-containers.backend = "docker";
  };
}
