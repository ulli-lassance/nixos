{ config, ... }:

{
  fileSystems."${config.settings.user.home}/ssd2" = {
    device = "/dev/disk/by-uuid/ad6a7e42-4ce2-47bb-a270-82d28cee2d37";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."${config.settings.user.home}/hd2" = {
    device = "/dev/disk/by-uuid/1d691822-1552-46ac-9a3f-c8f1688dd8e8";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
