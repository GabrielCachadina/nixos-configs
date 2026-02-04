{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.grafana = {
      image = "grafana/grafana-enterprise:latest";
      environment = {
        TZ = "Europe/Madrid";
        UID = "1000";
        GID = "1000";
      };
      volumes = [
        "/home/gabriel/Docker/Grafana:/var/lib/grafana"
      ];
      ports = [
        "3000:3000"
      ];
      autoStart = true;
    };
  };
}
