{ pkgs, ... }: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  boot.kernelParams = [ "i915.enable_guc=3" ];

  environment.systemPackages = [
    pkgs.nvtopPackages.intel
  ];
}
