{
  pkgs,
  config,
  ...
}:
{
  sops.secrets = {
    "user_password" = {
      neededForUsers = true;
    };
    "root_password" = {
      neededForUsers = true;
    };
  };

  users = {
    users."${config.settings.user.username}" = {
      isNormalUser = true;
      createHome = true;
      home = "${config.settings.user.home}";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      hashedPasswordFile = config.sops.secrets."user_password".path;
    };

    users.root = {
      hashedPasswordFile = config.sops.secrets."root_password".path;
    };
  };

  security = {
    sudo.execWheelOnly = true;
  };

  users.mutableUsers = false;
}
