{ pkgs, vars, ... }:

let
  wallpaper = ./../../../assets/wallpapers + "/${vars.wallpaper}";
in

{
  stylix.targets = {
    hyprpaper.enable = false;
  };

  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      wallpaper = [
        {
          path = "${wallpaper}";
          monitor = "DP-1";
        }
      ];
      ipc = true;
      splash = false;
    };
  };
}
