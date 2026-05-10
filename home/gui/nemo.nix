{
  pkgs,
  vars,
  ...
}:

{
  home.packages = with pkgs; [
    nemo-with-extensions
  ];

  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "${vars.terminal}";
      };
    };
  };
}
