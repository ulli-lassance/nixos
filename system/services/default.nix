{ ... }: {
  imports = [
    ./resolved.nix
    ./podman.nix
    ./ssh.nix
    ./virtualisation.nix
    ./bluetooth.nix
    ./audio.nix
  ];
}
