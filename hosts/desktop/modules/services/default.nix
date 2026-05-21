{ ... }:

{
  imports = [
    ./audio.nix
    ./polkit.nix
    ./keyring.nix
    ./tuned.nix
    ./mullvad-vpn.nix
  ];
}
