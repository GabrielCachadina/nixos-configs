{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.lidarr = {
      image = "lscr.io/linuxserver/lidarr:latest";
      environment = {
        TZ = "Europe/Madrid";
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "/home/gabriel/Docker/Lidarr:/config"
        "/home/gabriel/Media/music:/music"
        "/home/gabriel/Torrents:/downloads"
      ];
      ports = [
        "8686:8686"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 8686 ];
}
