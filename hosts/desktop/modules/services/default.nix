{ ... }:

{
  imports = [
    ./audio.nix
    ./gvfs.nix
    ./bluetooth.nix
    ./tuned.nix
    # ./resolved.nix
    ./virtualization.nix
    ./cloudflare-warp.nix
  ];
}
