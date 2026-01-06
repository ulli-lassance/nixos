{
  config,
  pkgs,
  inputs,
  vars,
  ...
}:
let
  keyPath = "/var/lib/sops/keys.txt";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = keyPath;

    age.generateKey = false;

    secrets = { };
  };

  environment.variables = {
    SOPS_AGE_KEY_FILE = keyPath;
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
