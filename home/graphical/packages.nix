{ pkgs, ... }:

{
  home.packages = with pkgs; [
    file-roller
    papers
    qalculate-gtk
    pavucontrol

    feishin

    qbittorrent

    inkscape
    gimp

    libreoffice
    hunspell
    hunspellDicts.en_US
    hunspellDicts.pt_BR
  ];

}
