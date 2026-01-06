{
  config,
  pkgs,
  vars,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    cifs-utils # Needed for mounting smb shares
  ];

  sops.secrets.smb_password = { };

  sops.templates."smb-secrets" = {
    content = ''
      username=${vars.username}
      domain="WORKGROUP"
      password=${config.sops.placeholder."smb_password"}
    '';
    mode = "0600";
  };

  fileSystems."/mnt/samba-storage" = {
    device = "//${vars.serverIP}/storage";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.mount-timeout=5s"
      "credentials=${config.sops.templates."smb-secrets".path}"
      "uid=1000"
      "gid=100"
      "vers=3.1.1"
    ];
  };
}
