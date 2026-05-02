{ pkgs, ... }:

{
  services.resolved = {
    enable = true;
    
    settings.Resolve = {
      Cache = true;
      LLMNR = "resolve";
      MulticastDNS = false;
      DNSSEC = false;
      DNSOverTLS = false;
    };
  };
}
