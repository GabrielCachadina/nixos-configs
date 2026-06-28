{ config, pkgs, ... }:


{
  # Definition from docker containers
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
  };
}
