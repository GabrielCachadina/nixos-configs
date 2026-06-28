{ config, pkgs, ... }:
let

  SaveNixOSConfig = pkgs.writeShellScript "SaveNixOSConfig" ''
     wall "Executing security copy of the /etc/nixos directory"
     rsync -av --no-owner --no-group --delete /etc/nixos/ /home/${config.globals.username}/Sync/NixOS/${config.globals.syncnixos}/
  '';
  AutoUpdateNixOS = pkgs.writeShellScript "AutoUpdateNixOS" ''
     sudo nix-channel --update
     sudo nixos-rebuild switch --upgrade
     sudo nix-env --delete-generations +2 --profile /nix/var/nix/profiles/system
     sudo nix-collect-garbage -d
  '';
  RemoveUnusedContainers = pkgs.writeShellScript "RemoveUnusedContainers" ''
     sudo docker image prune -a
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
      "25 1 * * *      root   ${RemoveUnusedContainers}"
    ];
  };
}
