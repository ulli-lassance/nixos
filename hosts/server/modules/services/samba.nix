{ vars, ... }:
{
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
      };
      storage = {
        path = "${vars.homeDirectory}";
        browseable = "yes";
        "writeable" = "yes";
        "guest ok" = "no";
        "force user" = "${vars.username}";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # for windows discovery
  # services.samba-wsdd = {
  #   openFirewall = true;
  #   enable = true;
  # };
}
