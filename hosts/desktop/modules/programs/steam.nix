{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = false;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [

        ];
    };
  };

  powerManagement.cpuFreqGovernor = "performance";
}
