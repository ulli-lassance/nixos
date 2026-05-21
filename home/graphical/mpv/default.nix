{ pkgs, ... }:

{
  imports = [
    ./profiles.nix
    ./input.nix
    ./mpv.nix
    ./script-opts/uosc.nix
    ./script-opts/memo.nix
    ./script-opts/thumbfast.nix
  ];

  programs.mpv = {
    enable = true;
    scripts = with pkgs; [
      mpvScripts.uosc
      mpvScripts.memo
      mpvScripts.thumbfast
      mpvScripts.builtins.autoload
      mpvScripts.mpris
    ];
  };
}
