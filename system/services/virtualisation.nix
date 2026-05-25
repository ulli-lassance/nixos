{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.settings.virtualMachines;
in
{
  options.settings.virtualMachines = {
    enable = lib.mkEnableOption "enables virtual machines via qemu and libvirtd";

    withGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enables the virt-manager GUI and spice USB redirection";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
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
                user = "${config.settings.user.username}"
                group = "libvirtd"
                namespaces = []
              '';
            };
          };
        };

        networking = {
          firewall.trustedInterfaces = [ "virbr0" ];
        };

        users.users."${config.settings.user.username}".extraGroups = [ "libvirtd" ];
      }

      (lib.mkIf cfg.withGui {
        programs.virt-manager.enable = true;
        virtualisation.spiceUSBRedirection.enable = true;
      })
    ]
  );
}
