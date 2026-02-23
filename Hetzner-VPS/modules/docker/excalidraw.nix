{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.excalidraw = {
      image = "excalidraw/excalidraw:latest";
      environment = {
        TZ = "Europe/Madrid";
      };
      ports = [
        "3030:80"
      ];
      autoStart = true;
    };
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."excalidraw.gabrielcachadina.com" = {
    addSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:3030";
      proxyWebsockets = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
