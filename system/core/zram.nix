{ ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  systemd.oomd.enable = true;
}
