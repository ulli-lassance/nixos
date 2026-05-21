{ config, inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";

    users = builtins.listToAttrs [
      {
        name = config.settings.user.username;
        value =
          { osConfig, ... }:
          {
            home.username = osConfig.settings.user.username;
            home.homeDirectory = osConfig.settings.user.home;
            home.stateVersion = osConfig.settings.stateVersion;

            imports = [
              ../../home
            ];
          };
      }
    ];
  };
}
