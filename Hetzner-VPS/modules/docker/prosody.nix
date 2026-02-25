{ config, pkgs, ... }:


let
  domain = "xmpp.gabrielcachadina.com";
  certDir = "/var/lib/acme/xmpp.gabrielcachadina.com"; # Real certificates

  # Read the ACME files at evaluation time and write to Nix store
  FullchainPEM =
    if builtins.pathExists "${certDir}/fullchain.pem"
    then pkgs.writeText "fullchain.pem" (builtins.readFile "${certDir}/fullchain.pem")
    else "/dev/null";

  keyPEM =
    if builtins.pathExists "${certDir}/key.pem"
    then pkgs.writeText "key.pem" (builtins.readFile "${certDir}/key.pem")
    else "/dev/null";


  prosodyConfig = pkgs.writeText "prosody.cfg.lua" ''
    admins = { "gabriel@${domain}" }
    
    -- Server Info --
    contact_info = {
      abuse = { "mailto:gabrielcachadina@protonmail.com" };
      admin = { "xmpp:gabriel@xmpp.gabrielcachadina.com" };
    };
    
    modules_enabled = {
    	-- Generally required
        "roster";	-- Allow users to have a roster. Recommended ;)
        "saslauth";	-- Authentication for clients and servers. Recommended if you want to log in. 
        "tls";		-- Add support for secure TLS on c2s/s2s connections
        "disco";	-- Service discovery

        -- Not essential, but recommended
	"private";	-- Private XML storage (for room bookmarks, etc.)
        "vcard";	-- User profiles (stored in PEP)
        "smacks";	-- Stream management and resumption (XEP-0198)
        "carbons";	-- Keep multiple clients in sync
	"admin_shell";	-- Shell to operate inside of prosody
	"blocklist";	-- Allow users to block communications with other users

	-- Nice to have
	"ping";		-- Replies to XMPP pings with pongs
        "mam";		-- Store messages in an archive and allow users to access it
	"proxy65"; 	-- Enables a file transfer proxy service which clients behind NAT can use
	"cloud_notify"; -- Enables support for sending “push notifications” to clients that need it
	"pep";		-- Enables users to publish their mood, activity, playing music and more
	"pep_simple";   -- Enables users to publish their avatar, mood, activity, playing music and more
    }
    -- These modules are auto-loaded, but should you want
    -- to disable them then uncomment them here:
    modules_disabled = {
      -- "offline"; -- Store offline messages
      -- "c2s"; -- Handle client connections
      -- "s2s"; -- Handle server-to-server connections
      -- "posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
    }

    limits = {
      c2s = {
        rate = "10kb/s";
        burst = "2s";
      };
      s2sin = {
        rate = "30kb/s";
        burst = "5s";
      }
    }

    -- Disable account creation by default, for security
    allow_registration = false
    
    c2s_require_encryption = true 	-- prevent clients from authenticating unless they are using encryption.
    s2s_require_encryption = true	-- prevent servers from authenticating unless they are using encryption.
    s2s_secure_auth = true		-- requires servers you communicate with to support encryption AND present valid, trusted certificates.

    -- Location of directory to find certificates in (relative to main config file):
    ssl = {
        key = "/certs/key.pem";
        certificate = "/certs/fullchain.pem";
    }
    

    ----------- Virtual hosts -----------
    -- You need to add a VirtualHost entry for each domain you wish Prosody to serve.
    -- Settings under each VirtualHost entry apply *only* to that host.
    VirtualHost "${domain}"

    Component "upload.${domain}" "http_file_share"
      modules_enabled = {
      --"acme_challenge_dir",
    }
    http_file_share_size_limit = 50*1024*1024 -- 50 MiB
    http_file_share_daily_quota = 200*1024*1024 -- 200 MiB per day per user
    http_file_share_global_quota = 512*1024*1024 -- 5 GiB total
    http_file_share_expires_after = 60 * 60 * 24 -- a day

    
    ---Set up a MUC (multi-user chat) room server on conference.example.com:
    Component "conference.${domain}" "muc"
    --- Store MUC messages in an archive and allow users to access it
    modules_enabled = { "vcard_muc", "muc_mam" }
    restrict_room_creation = false
    muc_tombstones = false
    muc_tombstone_expiry = 86400 * 7
  '';
in
{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";

    containers.prosody = {
      image = "prosodyim/prosody:13.0";
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

  services.nginx.enable = true;
  services.nginx.virtualHosts."xmpp.gabrielcachadina.com" = {
    addSSL = true;
    enableACME = true;
    
    serverAliases = [
      "upload.xmpp.gabrielcachadina.com"
      "conference.xmpp.gabrielcachadina.com"
    ];

    # Optionally proxy WebSocket/File share if needed
    locations."/" = {};
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabrielcachadina@protonmail.com";
  };


  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker 0755 1000 1000 -"
    "d /home/gabriel/Docker/Prosody 0755 1000 1000 -"
    "d /home/gabriel/Docker/Prosody/data 0755 1000 1000 -"
  ];

  networking.firewall.allowedTCPPorts = [ 
    80
    443
    5222 
    5269 
    5281 # For Files
  ];
}
