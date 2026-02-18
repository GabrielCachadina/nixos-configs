{ config, pkgs, ... }:

let
  traefikConf = pkgs.writeText "traefik.yml" ''
api:
  insecure: true
  dashboard: true

entryPoints:
  web:
    address: ":80"

http:
  routers:
    jellyfin:
      rule: "Host(`jellyfin.gabrielcachadina.com`)"
      entryPoints:
        - web
      service: jellyfin

  services:
    jellyfin:
      loadBalancer:
        servers:
          - url: "http://127.0.0.1:8096"

  '';
in
{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";

    containers.traefik = {
      image = "traefik:latest";
      pull = "always";

      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "${traefikConf}:/etc/traefik/traefik.yml"
      ];
      autoStart = true;
      networks = [ "host" ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 8080 ];
}

