{
  config,
  pkgs,
  vars,
  lib,
  ...
}:

let
  cfg = config.system.virtualMachines;
in
{
  options.system.virtualMachines = {
    enable = lib.mkEnableOption "enables virtual machines via qemu, libvirtd and enables the virt-manager gui.";
  };

  config = lib.mkIf cfg.enable {

    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
    };

    users.users."${vars.username}".extraGroups = [ "libvirtd" ];

    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
