{ config, lib, ... }:
let
  cfg = config.settings.avahi;
in
{
  options.settings.avahi = {
    enable = lib.mkEnableOption "enables avahi";
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      ipv6 = false;
      nssmdns4 = true;
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
