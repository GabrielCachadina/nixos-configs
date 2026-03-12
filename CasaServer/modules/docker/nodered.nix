{ config, pkgs, ... }:

{
  # Ensure directory exists with correct ownership
  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker/NodeRed 0755 1000 1000 -"
  ];

  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";

    containers.nodered = {
      image = "nodered/node-red:latest";
      volumes = [
        "/home/gabriel/Docker/NodeRed:/data"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 1880 ];
}
