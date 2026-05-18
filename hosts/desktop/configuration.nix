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
  ];

  # Toggle features for the desktop here
  system = {
    bluetooth.enable = true;
    virtualMachines.enable = true;
    ssh.enable = true;
    podman.enable = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs vars; };
    users."${vars.username}" = import ./home.nix;
    backupFileExtension = "backup";
  };

  networking.hostName = "desktop";

  stylix = {
    targets = {
      console.enable = true;
      qt.enable = true;
      gtk.enable = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "ntsync" ];
  };

  system.stateVersion = vars.stateVersion;
}
