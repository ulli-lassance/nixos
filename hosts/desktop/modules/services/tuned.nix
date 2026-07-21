{ pkgs, ... }: {
  services.tuned = {
    enable = true;
  };
}
