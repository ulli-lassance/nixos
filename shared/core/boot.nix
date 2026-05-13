{ ... }:

{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    # systemd-boot = {
    #   enable = true;
    #   configurationLimit = 10;
    # };

    limine = {
      enable = true;
      maxGenerations = 20;
    };
  };
}
