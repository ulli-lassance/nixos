{ pkgs, ... }:

{
  home.packages = with pkgs; [
    heroic
    prismlauncher
    fflogs

    # xivlauncher
    (callPackage ./xivlauncher-rb/xivlauncher.nix { })
  ];
}
