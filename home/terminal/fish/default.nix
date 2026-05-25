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
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];
  };
}
