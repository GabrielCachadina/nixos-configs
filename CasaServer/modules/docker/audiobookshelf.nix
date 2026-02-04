{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.audiobookshelf = {
      image = "ghcr.io/advplyr/audiobookshelf:latest";
      environment = {
        TZ = "Europe/Madrid";
        UID = "1000";
        GID = "1000";
      };
      volumes = [
        "/home/gabriel/Media/audiobooks:/audiobooks"
        "/home/gabriel/Media/podcasts:/podcasts"
        "/home/gabriel/Docker/Audiobookshelf:/config"
        "/home/gabriel/Docker/Audiobookshelf:/metadata"
      ];
      ports = [
        "13378:80"
      ];
      autoStart = true;
    };
  };
}
