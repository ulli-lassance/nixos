{ config, pkgs, ... }:

let
  # Set you WAN interface name (check with "ip addr")
  externalInterface = "enp2s0";
in
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.src_valid_mark" = 1;
    "net.ipv4.ip_forward" = 1;
  };

  sops.secrets.wg_server_private_key = {
    owner = "root";
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = externalInterface;
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    checkReversePath = "loose";
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.100.0.1/24" ];

      listenPort = 51820;

      privateKeyFile = config.sops.secrets.wg_server_private_key.path;

      postUp = [
        "${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT"
        "${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${externalInterface} -j MASQUERADE"
      ];
      postDown = [
        "${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT"
        "${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${externalInterface} -j MASQUERADE"
      ];

      peers = [
        {
          # iphone
          publicKey = "TPLeVbp3qn/JVuesGtTAzrciFTsINAv2nT4DqqEexE4=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
    qrencode
  ];
}
