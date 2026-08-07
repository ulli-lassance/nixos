{ ... }: {
  imports = [
    ./arr

    ./adguard.nix
    ./navidrome.nix
    ./jellyfin.nix
    ./vaultwarden.nix
    ./ddns-updater.nix
    # ./invidious.nix
    # ./feishin.nix
    ./radicale.nix
    ./4get.nix
    ./immich.nix
    ./freshrss.nix
    ./homepage.nix
  ];
}
