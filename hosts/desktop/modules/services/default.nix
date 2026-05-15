{ ... }:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./polkit.nix
    ./keyring.nix
    ./tuned.nix
    ./virtualisation.nix
    ./mullvad-vpn.nix
  ];
}
