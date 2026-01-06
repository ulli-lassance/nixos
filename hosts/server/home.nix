{ vars, ... }:

{
  home.username = vars.username;
  home.homeDirectory = vars.homeDirectory;
  home.stateVersion = vars.stateVersion;

  imports = [
    ../../home/cli
  ];
}
