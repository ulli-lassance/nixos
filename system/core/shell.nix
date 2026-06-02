{
  config,
  lib,
  pkgs,
  ...
}:

{
  users = {
    defaultUserShell = pkgs.fish;
  };

  programs.fish = {
    enable = true;

    shellAliases = { };

    interactiveShellInit = ''
      set fish_greeting

      set -gx GITHUB_TOKEN (cat ${config.sops.secrets.github_token.path})
    '';
  };
}
