{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.shell.enableFishIntegration = true;

  programs.fish = {
    enable = true;

    shellAliases = { };

    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];
  };
}
