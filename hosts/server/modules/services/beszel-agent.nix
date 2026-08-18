{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.beszel.agent = {
    enable = true;
    openFirewall = true;

    smartmon.enable = true;
    environment = {
      DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
      KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkXUOUDaoRTfJGIGjazg6ZB8ZJWXloNbn9YBD26KJxQ";
      GPU_COLLECTOR = "nvtop";
    };

    extraPath = [ pkgs.nvtopPackages.intel ];
  };

  systemd.services.beszel-agent.serviceConfig = {
    # needed to read the rootless podman socket
    User = lib.mkForce config.settings.user.username;
    DynamicUser = lib.mkForce false;
  };
}
