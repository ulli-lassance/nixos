{ pkgs, ... }:

{
  programs.discord = {
    enable = true;
    package = pkgs.discord-canary;
    settings.SKIP_HOST_UPDATE = true;
  };
}
