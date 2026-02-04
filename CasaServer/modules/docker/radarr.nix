{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      environment = {
        TZ = "Europe/Madrid";
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "/home/gabriel/Docker/Radarr:/config"
        "/home/gabriel/Media/movies:/movies"
        "/home/gabriel/Torrents:/downloads"
      ];
      ports = [
        "7878:7878"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 7878 ];
}
