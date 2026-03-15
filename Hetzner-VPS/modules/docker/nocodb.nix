{ config, pkgs, ... }:


{
  # Ensure directory exists with correct ownership
  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker/NocoDB 0755 1000 1000 -"
  ];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.nocodb = {
      image = "nocodb/nocodb:latest";
      user = "1000:1000";
      environment = {
        TZ = "Europe/Madrid";
      };
      volumes = [
        "/home/gabriel/Docker/NocoDB:/usr/app/data"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."nocodb.gabrielcachadina.com" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
