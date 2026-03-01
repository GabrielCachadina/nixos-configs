{ config, pkgs, ... }:
let
  MQTTConf = pkgs.writeText "mosquitto.conf" ''
${config.globals.mqtt_config}
  '';
  MQTTPasswdConf = pkgs.writeText "passwd" ''
${config.globals.mqtt_passwd}
  '';
  MQTTAclfileConf = pkgs.writeText "aclfile" ''
${config.globals.mqtt_aclfile}
  '';
  MQTTCAConf = pkgs.writeText "ca.crt" ''
${config.globals.mqtt_ca}
  '';
  MQTTServerCert = pkgs.writeText "server.crt" ''
${config.globals.mqtt_server_crt}
  '';
  MQTTServerKey = pkgs.writeText "server.key" ''
${config.globals.mqtt_server_key}
  '';
in

{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.mqtt = {
      image = "eclipse-mosquitto:latest";
      environment = {
        TZ = "Europe/Madrid";
      };
      volumes = [
        "${MQTTConf}:/mosquitto/config/mosquitto.conf"
  	"${MQTTPasswdConf}:/mosquitto/config/certs/passwd:ro"
  	"${MQTTAclfileConf}:/mosquitto/config/certs/aclfile"
  	"${MQTTCAConf}:/mosquitto/config/certs/ca.crt"
  	"${MQTTServerCert}:/mosquitto/config/certs/server.crt"
  	"${MQTTServerKey}:/mosquitto/config/certs/server.key"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."mqtt.gabrielcachadina.com" = {
    addSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8883";
      proxyWebsockets = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 8883 ];
}
