{ pkgs, ... }:

{
  home.packages = with pkgs; [
    heroic
    prismlauncher
    fflogs

    # Check if outdated, else build from source
    xivlauncher
    # (callPackage ./xivlauncher/xivlauncher.nix { })
  ];
}
