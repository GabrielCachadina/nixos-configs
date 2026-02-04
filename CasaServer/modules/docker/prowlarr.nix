{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      environment = {
        TZ = "Europe/Madrid";
        UID = "1000";
        GID = "1000";
      };
      volumes = [
        "/home/gabriel/Docker/Prowlarr:/config"
      ];
      ports = [
        "9696:9696"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 9696 ];
}
