{ config, pkgs, ... }:

{
  # Ensure directory exists with correct ownership
  systemd.tmpfiles.rules = [
    "Z /home/gabriel/Docker/n8n 0755 1000 1000 -"
  ];
  
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.n8n = {
      image = "docker.n8n.io/n8nio/n8n";
      environment = {
        GENERIC_TIMEZONE = "Europe/Madrid";
	TZ = "Europe/Madrid";
	N8N_SECURE_COOKIE = "false"; # Allow HTTP
      };
      volumes = [
        "/home/gabriel/Docker/n8n:/home/node/.n8n"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 5678 ];
}
