{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.firewall = {
    allowedTCPPorts = [
      7070
      4444
      4447
      7656
      27500
    ];
    allowedUDPPorts = [
      27500
    ];
  };

  services.i2pd = {
    enable = true;
    port = 27500;

    # in KBps, default is 32
    # bandwidth = 2048;

    proto = {
      http = {
        enable = true;
        address = "0.0.0.0";
        port = 7070;
        strictHeaders = false;
      };

      httpProxy = {
        enable = true;
        address = "0.0.0.0";
        port = 4444;
      };

      socksProxy = {
        enable = true;
        address = "0.0.0.0";
        port = 4447;
      };

      sam = {
        enable = true;
        address = "0.0.0.0";
        port = 7656;
      };
    };
  };
}
