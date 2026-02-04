{ config, pkgs, ... }:


{
virtualisation.oci-containers = {
  backend = "docker";

  containers.wireguard = {
    image = "lscr.io/linuxserver/wireguard:latest";

    autoStart = true;

    environment = {
      TZ = "Europe/Madrid";
      PUID = "1000";
      PGID = "1000";
      SERVERURL = "1.1.1.1";
      SERVERPORT = "51820";
      PEERS = "3";
      PEERDNS = "auto";
      ALLOWEDIPS = "0.0.0.0/0";
    };

    volumes = [
      "/home/gabriel/Sync/Wireguard/CasaServer:/config"
    ];
    #ports = [
    #  "51820:51820/udp"
    #];
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_MODULE"
      "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
    ];
    networks = [ "host" ];
    };
  };
  networking.firewall.allowedUDPPorts = [ 51820 ];
}
