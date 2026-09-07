{ config, pkgs, ... }:


{
  # Ensure directory exists with correct ownership
  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker 0755 1000 1000 -"
    "d /home/gabriel/Docker/Linkding 0755 1000 1000 -"
  ];
  
  virtualisation.oci-containers = {
    backend = "docker";
    containers.linkding = {
      image = "sissbruecker/linkding:latest";
      environment = {
        TZ = "Europe/Madrid";
        UID = "1000";
        GID = "1000";
      };
      volumes = [
        "/home/gabriel/Docker/Linkding:/etc/linkding/data"
      ];
      ports = [
        "9080:9090"
      ];
      autoStart = true;
    };
  };
}

