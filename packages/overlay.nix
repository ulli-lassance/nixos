final: prev: {
  xivlauncher-rb = prev.callPackage ./xivlauncher-rb { };
  brave-origin-beta = prev.callPackage ./brave-origin/package.nix { };
  xwayland-satellite-git = prev.callPackage ./xwayland-satellite.nix { };
  texstudio = prev.callPackage ./texstudio.nix { };
}
