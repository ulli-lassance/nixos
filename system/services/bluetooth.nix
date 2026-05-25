{ config, lib, ... }:

let
  cfg = config.settings.bluetooth;
in
{
  options.settings.bluetooth = {
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
  };
}
