{ ... }:

{
  imports = [
    ./settings.nix
    ./boot.nix
    ./locale.nix
    ./zram.nix
    ./network.nix
    ./nix.nix
    ./shell.nix
    ./sops
    ./users.nix
    ./storage-optimization.nix
  ];
}
