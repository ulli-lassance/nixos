{ ... }:

{
  imports = [
    ./samba.nix
    ./container-backup.nix
    ./nginx.nix
    ./wireguard
  ];
}
