{ ... }: {
  imports = [
    ./arr

    ./technitium.nix
    ./navidrome.nix
    ./jellyfin.nix
    ./vaultwarden.nix
    ./ddns-updater.nix
    ./radicale.nix
    ./4get.nix
    ./immich.nix
    ./freshrss.nix
    ./homepage.nix
    # ./thelounge.nix
    ./bezsel-hub.nix
  ];
}
