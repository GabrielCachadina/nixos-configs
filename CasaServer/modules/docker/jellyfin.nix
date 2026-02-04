{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.jellyfin = {
      image = "lscr.io/linuxserver/jellyfin:latest";
      environment = {
        TZ = "Europe/Madrid";
        UID = "1000";
        GID = "1000";
      };
      volumes = [
        "/home/gabriel/Docker/Jellyfin:/config"
        "/home/gabriel/Media/tvshows:/data/tvshows"
        "/home/gabriel/Media/movies:/data/movies"
        "/home/gabriel/Media/music:/data/music"
      ];
      ports = [
        "8096:8096"
      ];
      autoStart = true;
    };
  };
}
