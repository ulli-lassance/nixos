{ ... }: {
  imports = [
    ./samba.nix
    ./container-backup.nix
    ./podman-container-update.nix
    ./nginx.nix
    ./wireguard
    ./cloudflared.nix
  ];
}
