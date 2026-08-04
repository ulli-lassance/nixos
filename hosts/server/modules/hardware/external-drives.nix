{ config, ... }: {
  fileSystems."${config.settings.user.home}/ssd2" = {
    device = "/dev/disk/by-uuid/ad6a7e42-4ce2-47bb-a270-82d28cee2d37";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."${config.settings.user.home}/hd1" = {
    device = "/dev/disk/by-uuid/e0a29dfc-87f7-4465-8387-62ff29655731";
    fsType = "btrfs";
    options = [ "nofail" ];
  };
}
