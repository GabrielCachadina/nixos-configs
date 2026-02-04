{ config, pkgs, ... }:

{
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Wireguard Server
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "enp1s0";
  networking.nat.internalInterfaces = [ "wg0" ];
  #networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp1s0 -j MASQUERADE
      '';

      privateKey = "${config.globals.wireguard_server_privatekey}";
      peers = [
        { # TFN
  	  publicKey = "${config.globals.wireguard_tfn_publickey}";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { # NomadUSB
  	  publicKey = "${config.globals.wireguard_nomadusb_publickey}";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };
}
