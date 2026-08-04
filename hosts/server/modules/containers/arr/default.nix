{ ... }: {
  imports = [
    ./arr-net.nix
    ./make-data-dir.nix

    ./lidarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./bazarr.nix
    ./prowlarr.nix
    # ./qbittorrent.nix
    ./qbittorrent-vpn.nix
    ./flaresolverr.nix
    ./cleanuparr.nix
    ./seerr.nix
  ];
}
