# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{


  imports =
    [ # Include the results of the hardware scan.
      ./global.nix
      ./hardware-configuration.nix
      ./modules/bootloader.nix
      #./modules/services.nix
      ./modules/docker/audiobookshelf.nix
      ./modules/docker/dashy.nix
      ./modules/docker/grafana.nix
      ./modules/docker/jellyfin.nix
      ./modules/docker/kavita.nix
      ./modules/docker/lidarr.nix
      ./modules/docker/minecraftserver.nix
      ./modules/docker/nodeexporter.nix
      ./modules/docker/pihole.nix
      ./modules/docker/prometheus.nix
      ./modules/docker/prowlarr.nix
      ./modules/docker/qbittorrent.nix
      ./modules/docker/radarr.nix
      ./modules/docker/sonarr.nix
      ./modules/docker/watchtower.nix
      ./modules/docker/wireguard.nix
      ./modules/programs/neovim.nix
      ./modules/programs/programs.nix
      ./modules/services/cronjobs.nix
      ./modules/services/ssh.nix
      ./modules/services/syncthing.nix
      ./modules/services/wireguard.nix
  ];

  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Networking
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Timezone
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  time.timeZone = "Europe/Madrid";

  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Keyboard Layout
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };
  console.keyMap = "es";


  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Users
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  users.users.gabriel = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };


  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				System Version
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  system.stateVersion = "25.11"; # Did you read the comment?

}
