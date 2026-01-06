rec {
  username = "lassance";
  timezone = "America/Sao_Paulo";
  stateVersion = "25.11";

  theme = "rose-pine.yaml";
  wallpaper = "moon.jpg";

  name = "Lassance"; # For git auth.
  email = "ulli.lassance@gmail.com"; # For git auth.

  domain = "lassance.net.br";

  volumeDirectory = "/var/lib/containerVolumes"; # Directory for container volumes
  containerCache = "/var/cache/containerCache"; # Directory for container temp files,i.e cache/logs

  homeDirectory = "/home/${username}";

  serverIP = "192.168.15.3"; # Static local IP for the server host

}
