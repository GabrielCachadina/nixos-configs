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
        "/home/gabriel/Docker/qbittorrent:/config"
        "/home/gabriel/Torrents:/downloads"
      ];
      ports = [
        "8080:8080"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
