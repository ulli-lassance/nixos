{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tree
    fd
    ripgrep
    bat
    grc
    fzf
    jq
  ];
}
