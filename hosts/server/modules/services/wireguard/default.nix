{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets.wg_server_private_key = {
    owner = "root";
  };

  networking = {
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = config.settings.server.externalInterface;
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      trustedInterfaces = [ "wg0" ];
      allowedUDPPorts = [ config.networking.wg-quick.interfaces.wg0.listenPort ];
      checkReversePath = lib.mkForce "loose";
    };

    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.100.0.1/24" ];
        listenPort = 51820;
        privateKeyFile = config.sops.secrets.wg_server_private_key.path;

        peers = [
          {
            # iphone
            publicKey = "TPLeVbp3qn/JVuesGtTAzrciFTsINAv2nT4DqqEexE4=";
            allowedIPs = [ "10.100.0.2/32" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
    qrencode
  ];
}
