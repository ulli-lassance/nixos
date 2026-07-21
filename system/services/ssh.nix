{
  config,
  lib,
  ...
}:
let
  cfg = config.settings.ssh;
in
{
  options.settings.ssh = {
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
