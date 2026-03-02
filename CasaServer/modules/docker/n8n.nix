{ config, pkgs, ... }:


{
  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker 0755 1000 1000 -"
    "d /home/gabriel/Docker/n8n 0755 1000 1000 -"
  ];


  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.n8n = {
      image = "n8nio/n8n:latest";  # Official n8n image
      environment = {
        TZ = "Europe/Madrid";
        PUID = "1000";
        PGID = "1000";
        N8N_SECURE_COOKIE = "false";
        N8N_RUNNERS_ENABLED = "true";
        N8N_NATIVE_PYTHON_RUNNER = "true";
      };
      volumes = [
        "/home/gabriel/Docker/n8n:/home/node/.n8n"
      ];
      ports = [
        "5678:5678"
      ];
      autoStart = true;
    };
  }; 

  networking.firewall.allowedTCPPorts = [ 8686 ];
}
