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
          swtpm.enable = true;
          vhostUserPackages = with pkgs; [ virtiofsd ];
          # runs qemu as your user
          verbatimConfig = ''
            user = "${vars.username}"
            group = "libvirtd"
            namespaces = []
          '';
        };
      };
    };

    users.users."${vars.username}".extraGroups = [ "libvirtd" ];

    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
