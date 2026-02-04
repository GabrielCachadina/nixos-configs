{ config, pkgs, ... }:
let

  SaveNixOSConfig = pkgs.writeShellScript "SaveNixOSConfig" ''
     rsync -av --no-owner --no-group --delete /etc/nixos/ /home/${config.globals.username}/Sync/NixOS/${config.globals.syncnixos}/
  '';
  WakeSleepyJoe = pkgs.writeShellScript "WakeOnLan-SleepyJoe" ''
     wakeonlan -i 192.168.0.28 00:e0:4c:17:6b:b1
  '';
in
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
  };

  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Cronjobs
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * *      ${config.globals.username}    ${SaveNixOSConfig}"
      "0 * * * *      ${config.globals.username}    ${WakeSleepyJoe}"
    ];
  };

}
