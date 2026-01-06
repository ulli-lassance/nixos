{ vars, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = vars.name;
      email = vars.email;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
