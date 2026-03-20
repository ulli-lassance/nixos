{ config, vars, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  sops.secrets.cloudflare_dns = { };

  sops.templates."acme-cloudflare.env" = {
    owner = "acme";
    content = ''
      CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare_dns"}
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = vars.email;

    certs."${vars.domain}" = {
      domain = "*.lan.${vars.domain}";
      dnsProvider = "cloudflare"; # check Lego docs for your provider code

      # path to a file containing your API token
      environmentFile = config.sops.templates."acme-cloudflare.env".path;

      group = "nginx";
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
