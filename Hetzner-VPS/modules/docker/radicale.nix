{ config, pkgs, ... }:
let
  radicaleUsers = pkgs.writeText "users" ''
gabriel:${config.globals.radicale_pass}
  '';
  radicaleConfig = pkgs.writeText "config" ''
[server]
hosts = 0.0.0.0:5232

[auth]
type = htpasswd
htpasswd_filename = /data/users
htpasswd_encryption = plain

[storage]
filesystem_folder = /var/lib/radicale/collections
  '';
in
{
  # Ensure directory exists with correct ownership
  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker/Radicale 0755 1000 1000 -"
    "d /home/gabriel/Docker/Radicale/data 0755 1000 1000 -"
  ];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.radicale = {
      image = "ghcr.io/kozea/radicale:latest";
      user = "1000:1000";
      volumes = [
        "${radicaleConfig}:/etc/radicale/config"
        "/home/gabriel/Docker/Radicale/data:/var/lib/radicale"
      	"${radicaleUsers}:/data/users:ro"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."calendario.gabrielcachadina.com" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:5232";
      proxyWebsockets = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
