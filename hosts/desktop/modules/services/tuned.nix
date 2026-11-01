{ pkgs, ... }: {
  services.tuned = {
    enable = true;
    ppdSupport = true;
  };
}
