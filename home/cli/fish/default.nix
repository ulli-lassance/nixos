{
  config,
  lib,
  pkgs,
  ...
}:

{
  stylix.targets.fish.enable = true;

  home.shell.enableFishIntegration = true;

  programs.fish = {
    enable = true;

    shellAliases = { };

    interactiveShellInit = ''
      set fish_greeting

      fzf_configure_bindings --directory=\ec --history=\cr
    '';

    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
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
