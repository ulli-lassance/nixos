{
  config,
  lib,
  pkgs,
  vars,
  inputs,
  ...
}:

{
  imports = [
    ./hardware.nix
    ../../shared
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
    };

    network.hostName = "server";

    podman.enable = true;
    ssh.enable = true;
  };

  services.containerVolumeBackup = {
    enable = true;
    destination = "${config.settings.user.home}/ssd2/backup/containerVolumes";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs vars; };
    users."${config.settings.user.username}" = import ./home.nix;
    backupFileExtension = "backup";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;
  };

  system.stateVersion = config.settings.stateVersion;
}
