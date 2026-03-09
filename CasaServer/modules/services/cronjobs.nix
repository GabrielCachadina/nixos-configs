{ config, pkgs, ... }:
let

  SaveNixOSConfig = pkgs.writeShellScript "SaveNixOSConfig" ''
     wall "Executing security copy of the /etc/nixos directory"
     rsync -av --no-owner --no-group --delete /etc/nixos/ /home/${config.globals.username}/Sync/NixOS/${config.globals.syncnixos}/
  '';
  AutoUpdateNixOS = pkgs.writeShellScript "AutoUpdateNixOS" ''
     nixos-rebuild switch --upgrade
  '';
  GetPublicIP = pkgs.writeShellScript "GetPublicIP" ''
IP_FILE="$HOME/.last_public_ip"
PASSWORD="${config.globals.xmppbotpass}"

# Get current public IP
CURRENT_IP=$(curl -s https://api.ipify.org)

# If file doesn't exist, create it
if [ ! -f "$IP_FILE" ]; then
    echo "$CURRENT_IP" > "$IP_FILE"
    exit 0
fi

LAST_IP=$(cat "$IP_FILE")

# Compare IPs
if [ "$CURRENT_IP" != "$LAST_IP" ]; then
    MESSAGE="Public IP in "CasaServer" changed: $LAST_IP -> $CURRENT_IP"

    xmppc -j bot@xmpp.gabrielcachadina.com \
          -p "$PASSWORD" \
          -m message chat gabriel@xmpp.gabrielcachadina.com \
          "$MESSAGE"

    echo "$CURRENT_IP" > "$IP_FILE"
fi
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
      "0 * * * *	${config.globals.username}	${SaveNixOSConfig}"
      "05 1 * * *	root   				${AutoUpdateNixOS}"
      "0 8-22 * * *	${config.globals.username}	${GetPublicIP}"
    ];
  };
}
