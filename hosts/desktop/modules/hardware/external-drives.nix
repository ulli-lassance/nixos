{ ... }: {
  fileSystems."/mnt/ssd1" = {
    device = "/dev/disk/by-uuid/78d3ff13-76f2-4c14-af3f-e22b30d0eabb";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/hd1" = {
    device = "/dev/disk/by-uuid/aae85298-ced9-4e03-9910-7e550d30f36a";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
