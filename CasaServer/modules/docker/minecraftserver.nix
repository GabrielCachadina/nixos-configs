{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.minecraft-server = {
      image = "itzg/minecraft-server";
      environment = {
        TZ = "Europe/Madrid";
        UID = "1000";
        GID = "1000";
        EULA = "TRUE";
	MEMORY = "4G";
      };
      volumes = [
        "/home/gabriel/GameServers/Minecraft:/data"
      ];
      ports = [
        "25565:25565"
      ];
      autoStart = true;
    };
  };
}
