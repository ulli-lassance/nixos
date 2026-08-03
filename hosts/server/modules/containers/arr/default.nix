{ ... }: {
  imports = [
    ./arr-net.nix

    ./lidarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./bazarr.nix
    ./prowlarr.nix
    # ./qbittorrent.nixs
    ./qbittorrent-vpn.nix
    ./flaresolverr.nix
    ./cleanuparr.nix
    ./seerr.nix
  ];
}
