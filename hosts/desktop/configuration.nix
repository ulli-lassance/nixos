{ pkgs, config, ... }:

{
  imports = [
    ./hardware.nix
    ../../system
    ./home-manager.nix
    ./stylix.nix
    ./modules
  ];

  # Toggle settings for the desktop here
  settings = {
    user = {
      username = "lassance";
      email = "john.lassance@gmail.com";
    };

    network.hostName = "desktop";
    audio.enable = true;
    bluetooth.enable = true;
    virtualMachines = {
      enable = true;
      withGui = true;
    };
    ssh.enable = true;
  };

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

  system.stateVersion = config.settings.stateVersion;
}
