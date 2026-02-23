{ config, pkgs, ... }:
let

  SaveNixOSConfig = pkgs.writeShellScript "SaveNixOSConfig" ''
     wall "Executing security copy of the /etc/nixos directory"
     rsync -av --no-owner --no-group --delete /etc/nixos/ /home/${config.globals.username}/Sync/NixOS/${config.globals.syncnixos}/
  '';
  AutoUpdateNixOS = pkgs.writeShellScript "AutoUpdateNixOS" ''
     nixos-rebuild switch --upgrade
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
      "05 1 * * *      root   ${AutoUpdateNixOS}"
    ];
  };
}
