{ config, pkgs, ... }:

let
  sitePath = "/var/www/gabrielcachadina";
in
{
  systemd.tmpfiles.rules = [
    "d ${sitePath} 0755 nginx nginx - -"
  ];
  
  services.nginx.enable = true;
  services.nginx.virtualHosts."gabrielcachadina.com" = {
    addSSL = true;
    enableACME = true;
    root = sitePath;
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
