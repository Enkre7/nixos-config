{ config, pkgs, lib, ... }:

{
  # Apache
  services.httpd = {
    enable = true;
    enablePHP = true;
    phpPackage = pkgs.php82;
    adminAddr = "admin@localhost";
    
    virtualHosts."localhost" = {
      documentRoot = "/home/${config.user}/www";
      listen = [
        { ip = "*"; port = 80; }
        { ip = "*"; port = 443; ssl = true; }
      ];
      
      extraConfig = ''
        <Directory "/home/${config.user}/www">
          Options Indexes FollowSymLinks
          AllowOverride All
          Require all granted
        </Directory>
      '';
      
      sslServerCert = "/var/lib/ssl-certs/localhost.crt";
      sslServerKey = "/var/lib/ssl-certs/localhost.key";
    };
    
    extraModules = [ "rewrite" "ssl" "proxy" "proxy_http" "proxy_fcgi" ];
  };

  # Nginx
  services.nginx = {
    enable = true;
    virtualHosts."localhost-nginx" = {
      listen = [ { addr = "0.0.0.0"; port = 8080; } ];
      root = "/home/${config.user}/www";
      
      locations."~ \\.php$" = {
        extraConfig = ''
          fastcgi_pass unix:${config.services.phpfpm.pools.www.socket};
          fastcgi_index index.php;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
      };
      
      extraConfig = ''
        index index.php index.html index.htm;
        autoindex on;
      '';
    };
  };

  # PHP-FPM
  services.phpfpm.pools.www = {
    user = config.user;
    group = "users";
    phpPackage = pkgs.php82;
    settings = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 4;
      "pm.max_requests" = 500;
    };
  };

  # MySQL
  services.mysql = {
    enable = true;
    package = pkgs.mysql80;
    settings.mysqld = {
      port = 3306;
      bind-address = "127.0.0.1";
      max_connections = 200;
      innodb_buffer_pool_size = "256M";
      key_buffer_size = "32M";
    };
    ensureDatabases = [ "lamp" ];
    ensureUsers = [{
      name = config.user;
      ensurePermissions = { "*.*" = "ALL PRIVILEGES"; };
    }];
  };

  # Packages
  environment.systemPackages = with pkgs; [
    php82 php82Packages.composer
    php81 php81Packages.composer
    php83 php83Packages.composer
    dbeaver-bin nodejs_20 nodePackages.npm
    git openssl htop nettools
  ];

  # Certificats SSL
  systemd.tmpfiles.rules = [
    "d /home/${config.user}/www 0755 ${config.user} users -"
    "f /home/${config.user}/www/index.php 0644 ${config.user} users - <?php phpinfo(); ?>"
    "d /var/lib/ssl-certs 0755 root root -"
  ];

  systemd.services.generate-ssl-cert = {
    description = "Generate SSL certificate";
    wantedBy = [ "multi-user.target" ];
    before = [ "httpd.service" ];
    serviceConfig = { Type = "oneshot"; RemainAfterExit = true; };
    script = ''
      if [ ! -f /var/lib/ssl-certs/localhost.crt ]; then
        ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
          -keyout /var/lib/ssl-certs/localhost.key \
          -out /var/lib/ssl-certs/localhost.crt \
          -subj "/C=FR/ST=France/L=Paris/O=Development/CN=localhost"
        chmod 600 /var/lib/ssl-certs/localhost.key
        chmod 644 /var/lib/ssl-certs/localhost.crt
      fi
    '';
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 80 443 3306 8080 ];

  # Aliases
  environment.shellAliases = {
    lamp-start = "sudo systemctl start httpd nginx mysql phpfpm-www";
    lamp-stop = "sudo systemctl stop httpd nginx mysql phpfpm-www";
    lamp-restart = "sudo systemctl restart httpd nginx mysql phpfpm-www";
    lamp-status = "sudo systemctl status httpd nginx mysql phpfpm-www";
  };

  # Auto-start
  systemd.services.httpd.wantedBy = lib.mkForce [ "multi-user.target" ];
  systemd.services.nginx.wantedBy = lib.mkForce [ "multi-user.target" ];
  systemd.services.mysql.wantedBy = lib.mkForce [ "multi-user.target" ];
  systemd.services.phpfpm-www.wantedBy = lib.mkForce [ "multi-user.target" ];
}
