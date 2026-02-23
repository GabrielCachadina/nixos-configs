{ config, pkgs, ... }:

{
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Syncthing
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    user = "${config.globals.username}";
    dataDir = "/home/${config.globals.username}";
    configDir = "/home/${config.globals.username}/.config/syncthing";
    #guiAddress = "0.0.0.0:8384"; # To see the syncthing GUI from an external machine
  };
  #networking.firewall.allowedTCPPorts = [ 8384 ]; # To see the syncthing GUI from an external machine
}
