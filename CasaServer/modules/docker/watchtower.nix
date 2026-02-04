{ config, pkgs, ... }:


{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.watchtower = {
      image = "containrrr/watchtower:latest";
      environment = {
        TZ = "Europe/Madrid";
        WATCHTOWER_SCHEDULE = "0 0 4 * * *";
        WATCHTOWER_CLEANUP = "true";
        WATCHTOWER_DEBUG = "true";
      };
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
      autoStart = true;
    };
  };
}
