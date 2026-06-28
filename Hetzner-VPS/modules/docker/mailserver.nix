{ config, pkgs, ... }:

let
  domain = "gabrielcachadina.com";
  mailHost = "mail.${domain}";
in
{
  #################################
  # Docker
  #################################

  virtualisation.docker.enable = true;

  #################################
  # Minimal nginx ONLY for ACME
  #################################
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };
  services.nginx.enable = true;

  services.nginx.virtualHosts."mail.gabrielcachadina.com" = {
    enableACME = true;
    addSSL = true;

    serverAliases = [
      "smtp.gabrielcachadina.com"
      "imap.gabrielcachadina.com"
    ];

    locations."/" = {
      return = "444";
    };
  };
  #################################
  # Docker Mailserver Container
  #################################

  virtualisation.oci-containers = {
    backend = "docker";

    containers.mailserver = {
      image = "ghcr.io/docker-mailserver/docker-mailserver:latest";
      hostname = mailHost;
      autoStart = true;
      environment = {
        TZ = "Europe/Madrid";

        SSL_TYPE = "manual";
        SSL_CERT_PATH = "/etc/ssl/mail/fullchain.pem";
        SSL_KEY_PATH  = "/etc/ssl/mail/key.pem";

        ENABLE_FAIL2BAN = "1";
      };

      volumes = [
        "/home/gabriel/Docker/dms/mail-data:/var/mail"
        "/home/gabriel/Docker/dms/mail-state:/var/mail-state"
        "/home/gabriel/Docker/dms/mail-logs:/var/log/mail"
        "/home/gabriel/Docker/dms/config:/tmp/docker-mailserver"

        # Clean direct mount
        "/var/lib/acme/${mailHost}/fullchain.pem:/etc/ssl/mail/fullchain.pem:ro"
        "/var/lib/acme/${mailHost}/key.pem:/etc/ssl/mail/key.pem:ro"
      ];

      ports = [
        "25:25"
        "465:465"
        "587:587"
        "993:993"
      ];
    };
  };

  #################################
  # Directories
  #################################

  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker 0755 gabriel users -"
    "d /home/gabriel/Docker/dms 0755 gabriel users -"
    "d /home/gabriel/Docker/dms/mail-data 0755 gabriel users -"
    "d /home/gabriel/Docker/dms/mail-state 0755 gabriel users -"
    "d /home/gabriel/Docker/dms/mail-logs 0755 gabriel users -"
    "d /home/gabriel/Docker/dms/config 0755 gabriel users -"
  ];

  #################################
  # Firewall (CRITICAL)
  #################################

  networking.firewall.allowedTCPPorts = [
    80
    443
    25
    465
    587
    993
  ];
}
