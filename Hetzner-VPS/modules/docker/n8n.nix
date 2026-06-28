{ config, pkgs, ... }:

{
  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker/n8n 0755 1000 1000 -"
    "d /home/gabriel/Docker/n8n/files 0755 1000 1000 -"
  ];

  # ------------------------------------------------------------
  # Docker
  # ------------------------------------------------------------
  virtualisation.oci-containers = {
    backend = "docker";

    containers.n8n = {
      image = "n8nio/n8n";

      environment = {
        UID = "1000";
        GID = "1000";

        TZ = "Europe/Madrid";

        N8N_HOST = "n8n.gabrielcachadina.com";
        N8N_PROTOCOL = "https";
        N8N_EDITOR_BASE_URL = "https://n8n.gabrielcachadina.com/";
        WEBHOOK_URL = "https://n8n.gabrielcachadina.com/";

        N8N_PROXY_HOPS = "1";
        N8N_TRUST_PROXY = "true";
        N8N_SECURE_COOKIE = "true";
      };

      volumes = [
        "/home/gabriel/Docker/n8n:/home/node/.n8n"
        "/home/gabriel/Docker/n8n/files:/home/node/.n8n-files"
      ];

      # ❗ NOTE: "networks = [ "host" ]" is NOT valid here in NixOS OCI module
      extraOptions = [
        "--network=host"
      ];

      autoStart = true;
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts."n8n.gabrielcachadina.com" = {
      addSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:5678";
        proxyWebsockets = true;

        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Forwarded-Port $server_port;
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
