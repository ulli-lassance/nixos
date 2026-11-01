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
      nssmdns4 = true;
      openFirewall = true;

      settings = {
        server = {
          use-ipv6 = false;
        };
        publish = {
          disable-publishing = false;
          disable-user-service-publishing = false;
          publish-addresses = true;
          publish-domain = true;
          publish-workstation = true;
        };
      };
    };
  };
}
