{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../shared
    ./home-manager.nix
    ./modules
    ./settings.nix
  ];

  settings = {
    user = {
      username = "lassance";
      email = "john.lassance@gmail.com";
    };

    server = {
      domain = "lassance.net.br";
      lanIP = "192.168.15.3";
      externalInterface = "enp1s0";
    };

    network.hostName = "server";

    podman.enable = true;
    ssh.enable = true;
  };

  services.containerVolumeBackup = {
    enable = true;
    destination = "${config.settings.user.home}/ssd2/backup/containerVolumes";
  };


  boot = {
    kernelPackages = pkgs.linuxPackages;
  };

  system.stateVersion = config.settings.stateVersion;
}
