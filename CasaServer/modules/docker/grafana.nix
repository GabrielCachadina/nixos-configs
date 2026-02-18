{ config, pkgs, ... }:


{
  # Ensure directory exists with correct ownership
  systemd.tmpfiles.rules = [
    "Z /home/gabriel/Docker/Grafana 0755 1000 1000 -"
  ];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.grafana = {
      image = "grafana/grafana-enterprise:latest";
      user = "1000:1000";
      environment = {
        TZ = "Europe/Madrid";
      };
      volumes = [
        "/home/gabriel/Docker/Grafana:/var/lib/grafana"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
