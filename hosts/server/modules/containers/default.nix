{ ... }: {
  imports = [
    ./arr

    ./adguard.nix
    ./navidrome.nix
    ./jellyfin.nix
    ./vaultwarden.nix
    ./ddns-updater.nix
    ./slskd.nix
    # ./invidious.nix
    ./feishin.nix
    ./baikal.nix
    ./4get.nix
    ./immich.nix
  ];
}
