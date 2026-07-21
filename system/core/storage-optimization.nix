{ ... }: {
  # fstrim is an optimization for SSDs to maintain performance and lifespan.
  # This enables the fstrim service and timer, which runs weekly by default.
  services.fstrim.enable = true;
}
