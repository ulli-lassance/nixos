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
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  system = {
    podman.enable = true;
    ssh.enable = true;
  };

  # needed for rootless podman
  users.users."${vars.username}".linger = true;

  services.containerVolumeBackup = {
    enable = true;
    source = vars.volumeDirectory;
    destination = "${vars.homeDirectory}/ssd2/backup/containerVolumes";
    keepPruned = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs vars; };
    users."${vars.username}" = import ./home.nix;
    backupFileExtension = "backup";
  };

  networking.hostName = "server";

  boot = {
    kernelPackages = pkgs.linuxPackages;
  };

  system.stateVersion = vars.stateVersion;
}
