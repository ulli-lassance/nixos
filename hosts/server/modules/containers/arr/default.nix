{ ... }: {
  imports = [
    ./arr-net.nix
    ./make-data-dir.nix

    ./lidarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./bazarr.nix
    ./prowlarr.nix
    ./qbittorrent
    ./flaresolverr.nix
    ./slskd
    ./cleanuparr.nix
    ./seerr.nix
    ./autobrr.nix
  ];
}
