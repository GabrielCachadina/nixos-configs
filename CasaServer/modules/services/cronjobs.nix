{ config, pkgs, ... }:
let

  SaveNixOSConfig = pkgs.writeShellScript "SaveNixOSConfig" ''
     rsync -av --no-owner --no-group --delete /etc/nixos/ /home/${config.globals.username}/Sync/NixOS/${config.globals.syncnixos}/
  '';
in
{
  # networking.firewall.allowedTCPPorts = [ 8384 ]; # To see the syncthing GUI from an external machine
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Cronjobs
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * *      ${config.globals.username}    ${SaveNixOSConfig}"
    ];
  };
}
