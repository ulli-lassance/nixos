{ pkgs, ... }:

{
  services.resolved = {
    enable = true;

    settings.Resolve = {
      Cache = "yes";
      LLMNR = "resolve";
      MulticastDNS = "no";
      DNSSEC = "no";
      DNSOverTLS = "no";
    };
  };
}
