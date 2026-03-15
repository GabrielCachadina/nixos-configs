{ config, pkgs, ... }:

{

  # Ensure directory exists with correct ownership
  systemd.tmpfiles.rules = [
    "d /home/gabriel/Docker/MySQL 0755 1000 1000 -"
  ];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.mysql = {
      image = "mysql:latest";
      environment = {
        TZ  = "Europe/Madrid";
        UID = "1000";
        GID = "1000";
      };
      environment = {
        MYSQL_ROOT_PASSWORD = "${config.globals.mysql_root_password}";
	MYSQL_DATABASE = "${config.globals.mysql_database}";
        MYSQL_USER = "${config.globals.mysql_user}";
        MYSQL_PASSWORD = "${config.globals.mysql_password}";
      };
      volumes = [
        "./MySQL/mysql_data:/var/lib/mysql"
        "./MySQL/db/init.sql:/docker-entrypoint-initdb.d/init.sql"
        "./MySQL/db/my.cnf:/etc/mysql/my.cnf"
      ];
      networks = [ "host" ];
      autoStart = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 3306 ];
}
