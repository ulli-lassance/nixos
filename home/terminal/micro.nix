{ pkgs, ... }: {
  programs.micro = {
    enable = true;
    package = pkgs.micro;
    settings = {
      colorscheme = "simple";
    };
  };

  home.sessionVariables = {
    EDITOR = "micro";
  };
}
