{ config, pkgs, ... }:

let
  turnOffNoSessions = pkgs.writeShellScript "turn-off-no-sessions" ''
    # Exit if any user is logged in
    if who | grep .; then
      exit 0
    fi

    # Otherwise shut down
    shutdown -h now
  '';
  logSync = pkgs.writeShellScript "log-sync" ''
    set -euo pipefail

    date '+%Y-%m-%d %H:%M:%S' > /home/${config.globals.username}/Sync/${config.globals.username}
  '';
  SaveNixOSConfig = pkgs.writeShellScript "SaveNixOSConfig" ''
     rsync -av --no-owner --no-group --delete /etc/nixos/ /home/${config.globals.username}/Sync/${config.globals.syncnixos}/
  '';
in
{
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
  #			SSH
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "${config.globals.username}" ];
    };
  };
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
  #			WOL
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
  networking = {
    interfaces = {
      enp2s0 = { # use "ip a" to know the correct interface
        wakeOnLan.enable = true;
      };
    };
    firewall = {
      allowedUDPPorts = [ 9 ];
    };
  };
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
  #			Syncthing
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    user = "${config.globals.username}";
    dataDir = "/home/${config.globals.username}";
    configDir = "/home/${config.globals.username}/.config/syncthing";
    # guiAddress = "0.0.0.0:8384"; # To see the syncthing GUI from an external machine
  };
  # networking.firewall.allowedTCPPorts = [ 8384 ]; # To see the syncthing GUI from an external machine
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
  #			cronjobs
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * *	root				${turnOffNoSessions}"
      "* * * * *	${config.globals.username}	${logSync}"
      "*/4 * * * *	${config.globals.username}	${SaveNixOSConfig}"
    ];
  };


}
