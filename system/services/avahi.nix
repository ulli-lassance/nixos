{ config, lib, ... }:
let
  cfg = config.settings.avahi;
in
{
  options.settings.avahi = {
    enable = lib.mkEnableOption "enables avahi";
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;

      publish = {
        enable = true;
        addresses = true;
        domain = true;
        userServices = true;
        workstation = true;
      };

      extraServiceFiles = {
        smb = ''
          <service-group>
            <name replace-wildcards="yes">%h</name>
            <service>
              <type>_smb._tcp</type>
              <port>445</port>
            </service>
            <service>
              <type>_device-info._tcp</type>
              <port>0</port>
              <txt-record>model=RackMac</txt-record>
            </service>
          </service-group>
        '';
      };
    };
  };
}
