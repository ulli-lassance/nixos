{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.settings = {
    server = {
      domain = mkOption { type = types.str; };

      volumeDirectory = mkOption {
        type = types.str;
        default = "/var/lib/containerVolumes";
        description = "directory for container volumes";
      };

      containerCache = mkOption {
        type = types.str;
        default = "/var/cache/containerCache";
        description = "directory for container temp files,i.e cache/logs";
      };

      lanIP = mkOption {
        type = types.str;
        description = "static lan ip of server";
      };

      externalInterface = mkOption {
        type = types.str;
        default = "enp1s0";
        description = "outward-facing internet interface";
      };
    };
  };
}
