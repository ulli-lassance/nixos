{ pkgs, ... }:

{
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
      ];
    };
  };

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
  ];
}
