{ config, pkgs, ... }:
let
  vikunjaConf = pkgs.writeText "config.yml" ''
    service.enableregistration: false
  '';
in
{
  # Ensure directory exists with correct ownership
  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker/Vikunja 0755 1000 1000 -"
    "d /home/gabriel/Docker/Vikunja/db 0755 1000 1000 -"
    "d /home/gabriel/Docker/Vikunja/files 0755 1000 1000 -"
  ];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.vikunja = {
      image = "vikunja/vikunja:latest";
      user = "1000:1000";
      environment = {
        TZ = "Europe/Madrid";
        VIKUNJA_SERVICE_JWTSECRET = "${config.globals.vikunja_jwt}";
        VIKUNJA_SERVICE_PUBLICURL = "https://vikunja.gabrielcachadina.com";
        VIKUNJA_DATABASE_PATH = "/db/vikunja.db";
      };
      volumes = [
        "/home/gabriel/Docker/Vikunja/db:/db"
        "/home/gabriel/Docker/Vikunja/files:/app/vikunja/files"
      	"${vikunjaConf}:/etc/vikunja/config.yml:ro"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."vikunja.gabrielcachadina.com" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:3456";
      proxyWebsockets = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
