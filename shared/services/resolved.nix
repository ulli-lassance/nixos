{ config, lib, ... }:

let
  cfg = config.settings.resolved;
in
{
  options.settings.resolved = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enables the systemd-resolved daemon";
    };
  };

  config = lib.mkIf cfg.enable {
    services.resolved = {
      enable = true;

      settings.Resolve = {
        Cache = "yes";
        LLMNR = "yes";
        MulticastDNS = "yes";
        DNSSEC = "no";
        DNSOverTLS = "no";
      };
    };

    # multicastDNS port
    networking.firewall.allowedUDPPorts = [ 5353 ];
  };
}
