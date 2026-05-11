{
  config,
  pkgs,
  vars,
  lib,
  ...
}:

let
  cfg = config.system.ssh;
in
{
  options.system.ssh = {
    enable = lib.mkEnableOption "enables ssh";
  };

  config = lib.mkIf cfg.enable {

    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        UsePAM = true;
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };
  };
}
