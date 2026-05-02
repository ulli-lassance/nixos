{ pkgs, ... }:

{
  services.tuned = {
    enable = true;
    package = pkgs.tuned;
  };
}
