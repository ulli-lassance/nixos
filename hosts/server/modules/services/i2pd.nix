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
    ];
  };

  services.i2pd = {
    enable = true;

    bandwidth = 2048;

    proto = {
      http = {
        enable = true;
        address = "0.0.0.0";
        port = 7070;
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
