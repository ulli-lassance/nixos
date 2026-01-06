{ config, lib, ... }:

let
  cfg = config.system.bluetooth;
in
{
  options.system.bluetooth = {
    enable = lib.mkEnableOption "enables the bluetooth";
  };

  config = lib.mkIf cfg.enable {

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    services.blueman.enable = true;
  };
}
