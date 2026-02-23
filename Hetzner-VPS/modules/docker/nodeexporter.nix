{ config, pkgs, ... }:

let
  nodeexporterConf = pkgs.writeText "web.yml" ''
    basic_auth_users:
      ${config.globals.nodeexporter_localhost_user}: ${config.globals.nodeexporter_localhost_pass_hash}
  '';
in
{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.nodeexporter = {
      image = "quay.io/prometheus/node-exporter:latest";
      environment = {
        TZ  = "Europe/Madrid";
        UID = "1000";
        GID = "1000";
      };
      cmd = [
        "--path.rootfs=/host"
        "--web.config.file=/etc/prometheus/web.yml"
      ];
      volumes = [
        "/:/host:ro,rslave"
  	"${nodeexporterConf}:/etc/prometheus/web.yml:ro"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  
  services.nginx.enable = true;
  services.nginx.virtualHosts."hetzner-vps.gabrielcachadina.com" = {
    addSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:9100";
      proxyWebsockets = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
