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
      ports = [ "9090:9090" ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  
  networking.firewall.allowedTCPPorts = [ 9090 ];
}

