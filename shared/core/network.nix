{ ... }:

{
  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}
