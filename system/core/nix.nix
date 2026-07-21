{
  config,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = [
        "${config.settings.user.username}"
      ];

      extra-substituters = [
        "https://hyprland.cachix.org"
        "https://noctalia.cachix.org"
      ];

      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };

  # we need git for flakes
  environment.systemPackages = [ pkgs.git ];

  programs.nh = {
    enable = true;
    flake = "${config.settings.user.home}/nixos";
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 10 --keep-since 7d";
    };
  };
}
