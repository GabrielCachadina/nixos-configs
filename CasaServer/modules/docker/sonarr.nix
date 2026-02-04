{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      environment = {
        TZ = "Europe/Madrid";
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "/home/gabriel/Docker/Sonarr:/config"
        "/home/gabriel/Media/tvshows:/tv"
        "/home/gabriel/Torrents:/downloads"
      ];
      ports = [
        "8989:8989"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 8989 ];
}
