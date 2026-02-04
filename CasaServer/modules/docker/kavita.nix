{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.kavita = {
      image = "lscr.io/linuxserver/kavita:latest";
      environment = {
        TZ = "Europe/Madrid";
        UID = "1000";
        GID = "1000";
      };
      volumes = [
        "/home/gabriel/Docker/Kavita:/config"
        "/home/gabriel/Media/books:/data"
      ];
      ports = [
        "5000:5000"
      ];
      autoStart = true;
    };
  };
}
