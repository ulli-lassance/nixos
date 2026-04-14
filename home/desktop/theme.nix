{ lib, ... }:

{
  stylix.targets = {

    qt = {
      enable = true;
      standardDialogs = "xdgdesktopportal";
      platform = "qtct";
    };

    gtk = {
      enable = true;
      fonts.enable = true;
    };

    fontconfig = {
      enable = true;
      fonts.enable = true;
      listTargetIndex.enable = true;
    };

  };

  gtk = {
    enable = true;
    gtk4.theme = lib.mkForce null;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
