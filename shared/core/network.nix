{ config, ... }:

{
  networking = {
    hostName = config.settings.network.hostName;

    networkmanager.enable = true;

    nftables.enable = true;

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      checkReversePath = "loose";
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}
