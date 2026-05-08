{ ... }:

{
  imports = [
    ./boot.nix
    ./locale.nix
    ./zram.nix
    ./network.nix
    ./nix.nix
    ./sops
    ./users.nix
    ./stylix.nix
    ./storage-optimization.nix
  ];
}
