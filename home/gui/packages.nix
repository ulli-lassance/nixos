{ pkgs, ... }:

{
  home.packages = with pkgs; [
    file-roller
    evince
    qalculate-gtk
    pavucontrol

    feishin

    qbittorrent
    nicotine-plus
    remmina

    inkscape
    gimp

    libreoffice
    hunspell
    hunspellDicts.en_US
    hunspellDicts.pt_BR
  ];

}
