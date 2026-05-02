final: prev: {
  xivlauncher-rb = prev.callPackage ./xivlauncher-rb { };
  brave-origin-beta = prev.callPackage ./brave/make-brave.nix { } (import ./brave/brave-origin-beta.nix);
}
