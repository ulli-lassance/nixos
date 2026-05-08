{ ... }:

{
  imports = [
    ./audio.nix
    ./gvfs.nix
    ./bluetooth.nix
    ./polkit.nix
    ./keyring.nix
    ./tuned.nix
    ./resolved.nix
    ./virtualization.nix
    ./mullvad-vpn.nix
  ];
}
