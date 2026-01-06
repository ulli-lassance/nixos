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
    services.fail2ban = {
      enable = true;
      maxretry = 3;
      bantime = "24h";
      ignoreIP = [
        "192.168.15.2"
        "192.168.15.3"
        "192.168.15.4"
      ];
    };
  };
}
