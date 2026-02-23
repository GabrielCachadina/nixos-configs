{ config, pkgs, ... }:


{
  # Ensure directory exists with correct ownership
  systemd.tmpfiles.rules = [
    "D /home/gabriel/Docker 0755 1000 1000 -"
    "D /home/gabriel/Docker/Grafana 0755 1000 1000 -"
  ];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.grafana = {
      image = "grafana/grafana-enterprise:latest";
      user = "1000:1000";
      environment = {
        TZ = "Europe/Madrid";
      };
      volumes = [
        "/home/gabriel/Docker/Grafana:/var/lib/grafana"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  
  services.nginx.enable = true;
  services.nginx.virtualHosts."grafana.gabrielcachadina.com" = {
    addSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
