{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../system
    ./home-manager.nix
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

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "ntsync" ];
  };

  system.stateVersion = config.settings.stateVersion;
}
