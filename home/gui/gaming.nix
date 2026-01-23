{ pkgs, ... }:

{
  home.packages = with pkgs; [
    heroic
    prismlauncher
    fflogs
    # lutris

    # Check if outdated, else build from source
    xivlauncher
    # (callPackage ./xivlauncher/xivlauncher.nix { })
  ];
}
