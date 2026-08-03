{ pkgs, ... }: {
  programs.micro = {
    enable = true;
    package = pkgs.micro;
    settings = {
      colorscheme = "simple";
      clipboard = "terminal";
    };
  };

  home.sessionVariables = {
    EDITOR = "micro";
  };

}
