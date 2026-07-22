{ config, ... }: {
  # Don't forget to set a password with 'sudo smbpasswd -a <your-username>'
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "n150";
        "netbios name" = "n150";
        "security" = "user";
        "guest account" = "nobody";
        "map to guest" = "bad user";

        "map archive" = "no";
        "map hidden" = "no";
        "map system" = "no";
        "store dos attributes" = "yes";
      };
      storage = {
        path = "${config.settings.user.home}";
        browseable = "yes";
        "writeable" = "yes";
        "guest ok" = "no";
        "force user" = "${config.settings.user.username}";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # for windows discovery
  services.samba-wsdd = {
    openFirewall = true;
    enable = true;
  };
}
