{ ... }: {
  imports = [
    ./hardware.nix
    ./amdGPU.nix
    ./external-drives.nix
  ];
}
