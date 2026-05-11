{ pkgs, ... }:

{
  services.resolved = {
    enable = true;

    settings.Resolve = {
      Cache = "yes";
      LLMNR = "resolve";
      MulticastDNS = "yes";
      DNSSEC = "no";
      DNSOverTLS = "no";
    };
  };

  # multicastDNS port
  networking.firewall.allowedUDPPorts = [ 5353 ];
}
