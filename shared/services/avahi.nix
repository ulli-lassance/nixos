{
  config,
  pkgs,
  vars,
  lib,
  ...
}:

let
  cfg = config.system.avahi;
in
{
  options.system.avahi = {
    enable = lib.mkEnableOption "enables avahi";
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      domainName = "lan";
      openFirewall = true;

      publish = {
        enable = true;
        addresses = true;
        domain = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
