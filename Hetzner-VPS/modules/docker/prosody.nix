{ config, pkgs, ... }:

let
  domain = "xmpp.gabrielcachadina.com";

  certDir = "/var/lib/acme/xmpp.gabrielcachadina.com";

  # Read the ACME files at evaluation time and write to Nix store
  FullchainPEM = pkgs.writeText "fullchain.pem" (builtins.readFile "${certDir}/fullchain.pem");
  keyPEM      = pkgs.writeText "key.pem" (builtins.readFile "${certDir}/key.pem");

  prosodyConfig = pkgs.writeText "prosody.cfg.lua" ''
    admins = { "admin@${domain}" }

    modules_enabled = {
        "roster";
        "saslauth";
        "tls";
        "disco";
        "private";
        "vcard";
        "ping";
        "smacks";
        "carbons";
        "mam";
        "omemo";
    }

    allow_registration = false
    c2s_require_encryption = true
    s2s_secure_auth = true

    ssl = {
        key = "/certs/key.pem";
        certificate = "/certs/fullchain.pem";
    }

    VirtualHost "${domain}"
  '';
in
{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";

    containers.prosody = {
      image = "prosody/prosody:latest";
      environment = { TZ = "Europe/Madrid"; };
      volumes = [
        "/home/gabriel/Docker/Prosody/data:/var/lib/prosody"
        "${FullchainPEM}:/certs/fullchain.pem:ro"
        "${keyPEM}:/certs/key.pem:ro"
        "${prosodyConfig}:/etc/prosody/prosody.cfg.lua:ro"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };

  systemd.tmpfiles.rules = [
    "D /home/gabriel/Docker 0755 1000 1000 -"
    "D /home/gabriel/Docker/Prosody 0755 1000 1000 -"
    "D /home/gabriel/Docker/Prosody/data 0755 1000 1000 -"
  ];

  networking.firewall.allowedTCPPorts = [ 5222 5269 ];
}
