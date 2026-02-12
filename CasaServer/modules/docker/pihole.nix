{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.pihole = {
      image = "pihole/pihole:latest";
      environment = {
        TZ = "Europe/Madrid";
        PUID = "1000";
        PGID = "1000";
	FTLCONF_webserver_api_password = "${config.globals.pihole_password}";
      };
      volumes = [
        "/home/gabriel/Docker/Pihole/etc-pihole:/etc/pihole"
        "/home/gabriel/Docker/Pihole/etc-dnsmasq.d:/etc/dnsmasq.d"
      ];
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "67:67/udp"
        "80:80/tcp"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 ];
}
