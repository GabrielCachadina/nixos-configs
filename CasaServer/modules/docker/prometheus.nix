{ config, pkgs, ... }:

let
  nodeexporterConf = pkgs.writeText "web.yml" ''
    global:
      scrape_interval: 5m

    scrape_configs:
      - job_name: "Linode1"
        static_configs:
          - targets: ["sli1.gabrielcachadina.com"]
        basic_auth:
          username: "${config.globals.nodeexporter_linode_user}"
          password: "${config.globals.nodeexporter_linode_pass}"

      - job_name: "HomeServer"
        static_configs:
          - targets: ["localhost:9100"]
        basic_auth:
          username: "${config.globals.nodeexporter_localhost_user}"
          password: "${config.globals.nodeexporter_localhost_pass}"
    
      - job_name: "GabrielPC"
        static_configs:
          - targets: ["192.168.0.18:9100"]
        basic_auth:
          username: "${config.globals.nodeexporter_gabrielpc_user}"
          password: "${config.globals.nodeexporter_gabrielpc_pass}"

      - job_name: "Hetzner-VPS"
        static_configs:
          - targets: ["hetzner-vps.gabrielcachadina.com"]
        basic_auth:
          username: "${config.globals.nodeexporter_hetznervps_user}"
          password: "${config.globals.nodeexporter_hetznervps_pass}"
  '';
in
{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";

    containers.prometheus = {
      image = "prom/prometheus:latest";
      user = "root";
      volumes = [
        "/home/gabriel/Docker/Prometheus/prometheus-data:/prometheus"
        "${nodeexporterConf}:/etc/prometheus/prometheus.yml:ro"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  
  networking.firewall.allowedTCPPorts = [ 9090 ];
}

