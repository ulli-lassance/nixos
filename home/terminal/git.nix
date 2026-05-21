{ osConfig, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = osConfig.settings.user.name;
      email = osConfig.settings.user.email;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
