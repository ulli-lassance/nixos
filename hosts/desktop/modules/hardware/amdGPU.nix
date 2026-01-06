{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # needed for Steam/Wine
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = [
    pkgs.nvtopPackages.amd
  ];
}
