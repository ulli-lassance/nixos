{ pkgs ? import <nixpkgs> { config.allowUnfree = true; }, ... }:

{

  home.packages = with pkgs; [
    xivlauncher
    (callPackage ./fflogs { })
    # (callPackage ./xivlauncher-rb { })
  ];
}
