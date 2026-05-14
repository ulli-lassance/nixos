{ pkgs, ... }:

{
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
}
