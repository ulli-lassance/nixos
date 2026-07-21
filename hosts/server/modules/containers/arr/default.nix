{ ... }: {
  imports = [
    ./arr-net.nix

    ./lidarr.nix
    ./radarr.nix
    ./bazarr.nix
    ./prowlarr.nix
    ./qbittorrent.nix
    ./flaresolverr.nix
    ./cleanuparr.nix
  ];
}
