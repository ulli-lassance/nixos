{ osConfig, ... }:

{
  home.username = osConfig.settings.user.username;
  home.homeDirectory = osConfig.settings.user.home;
  home.stateVersion = osConfig.settings.stateVersion;

  imports = [
    ../../home
  ];
}
