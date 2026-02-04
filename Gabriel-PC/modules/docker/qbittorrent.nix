{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";

    containers.qbittorrent = {
      image = "lscr.io/linuxserver/qbittorrent:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Madrid";
        WEBUI_PORT = "8080";
        TORRENTING_PORT = "6881";
      };
      volumes = [
        "/home/${config.globals.username}/Docker/:/config"
        "/home/${config.globals.username}/Torrents:/downloads"
      ];
      ports = [
        "127.0.0.1:8080:8080"
      ];
      autoStart = true;
    };
  };
}



