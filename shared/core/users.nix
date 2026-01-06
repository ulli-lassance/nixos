{
  pkgs,
  vars,
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

  users.users."${vars.username}" = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${vars.username}";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    hashedPasswordFile = config.sops.secrets."user_password".path;
  };

  users.users.root = {
    hashedPasswordFile = config.sops.secrets."root_password".path;
  };

  users.mutableUsers = false;

  programs.fish.enable = true;
}
