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
      networks = [ "host" ];
      autoStart = true;
    };
  };
  networking.firewall.allowedUDPPorts = [ 53 67 ];
  networking.firewall.allowedTCPPorts = [ 53 80];
}
