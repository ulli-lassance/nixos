{ vars, pkgs, ... }:

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
        vars.username
      ];
    };
  };

  # we need git for flakes
  environment.systemPackages = [ pkgs.git ];

  programs.nh = {
    enable = true;
    flake = "${vars.homeDirectory}/nixos";
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 10 --keep-since 7d";
    };
  };
}
