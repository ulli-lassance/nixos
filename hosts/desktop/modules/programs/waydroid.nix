{
  config,
  lib,
  pkgs,
  ...
}:

let
  # find your GPU path with: ls -l /dev/dri/by-path/
  gpuRenderNode = "/dev/dri/by-path/pci-0000:03:00.0-render";
in
{
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  networking.firewall.trustedInterfaces = [ "waydroid0" ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  systemd.services.waydroid-container = {
    serviceConfig = {
      Delegate = true;
      CPUAccounting = true;
      MemoryAccounting = true;
      TasksAccounting = true;

      ExecStartPre = lib.mkAfter [
        (pkgs.writeShellScript "waydroid-gpu-fix-pre" ''
          set -e
          PROP_FILE="/var/lib/waydroid/waydroid.prop"

          mkdir -p /var/lib/waydroid
          touch "$PROP_FILE"
          chown root:root "$PROP_FILE"
          chmod 644 "$PROP_FILE"

          # Function to set properties (removes old, adds new)
          set_prop() {
            ${pkgs.gnused}/bin/sed -i "/^$1=/d" "$PROP_FILE"
            echo "$1=$2" >> "$PROP_FILE"
          }

          # Force Intel GPU (GBM/Mesa)
          set_prop ro.hardware.gralloc gbm
          set_prop ro.hardware.egl mesa
          set_prop gralloc.gbm.device ${gpuRenderNode}

          # Clean empty lines
          ${pkgs.gnused}/bin/sed -i '/^$/d' "$PROP_FILE"
        '')
      ];
    };
  };
}

# waydroid script:

# nix shell github:nix-community/NUR#repos.ataraxiasjel.waydroid-script -c sudo waydroid-script

# select anddroid 13 and use libhoudini for intel and libndk for amd cpu
