{ config, vars, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  sops.secrets.cloudflare_dns = {};

  sops.templates."acme-cloudflare.env".content = ''
    CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare_dns"}
  '';

  security.acme = {
    acceptTerms = true;
    defaults.email = vars.email;

    certs."${vars.domain}" = {
      domain = "*.lan.${vars.domain}";
      dnsProvider = "cloudflare"; # Check Lego docs for your provider code

      # Path to a file containing your API token
      environmentFile = config.sops.secrets.cloudflare_dns.path;

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
