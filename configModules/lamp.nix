{ config, pkgs, lib, ... }:

{
  # Services web - Apache et Nginx
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
      
      # Configuration SSL auto-signée
      sslServerCert = "/var/lib/acme/localhost/cert.pem";
      sslServerKey = "/var/lib/acme/localhost/key.pem";
    };
    
    extraModules = [
      "rewrite"
      "ssl"
      "proxy"
      "proxy_http"
      "proxy_fcgi"
    ];
  };

  # Nginx en parallèle sur le port 8080
  services.nginx = {
    enable = true;
    
    virtualHosts."localhost-nginx" = {
      listen = [
        { addr = "0.0.0.0"; port = 8080; }
      ];
      
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

  # PHP-FPM pour Nginx
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

  # MySQL 5.7
  services.mysql = {
    enable = true;
    package = pkgs.mysql57;
    
    settings = {
      mysqld = {
        port = 3306;
        bind-address = "127.0.0.1";
        max_connections = 200;
        # Configuration optimisée pour le développement
        innodb_buffer_pool_size = "256M";
        key_buffer_size = "32M";
      };
    };
    
    ensureDatabases = [ "laragon" ];
    ensureUsers = [
      {
        name = config.user;
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # PHP 8.2 et PHP 7.4
  environment.systemPackages = with pkgs; [
    # PHP 8.2 (par défaut)
    php82
    php82Packages.composer
    
    # PHP 7.4 (alternatif)
    php74
    php74Packages.composer
    
    # PHPMyAdmin
    phpmyadmin
    
    # HeidiSQL équivalent (DBeaver est un excellent client SQL multiplateforme)
    dbeaver-bin
    
    # Outils utiles pour le développement web
    nodejs_20
    nodePackages.npm
    git
    
    # Certificats SSL auto-signés
    openssl
    
    # Outils de monitoring
    htop
    nettools
  ];

  # Configuration PHP 8.2
  environment.etc."php82/php.ini".text = ''
    max_execution_time = 300
    memory_limit = 512M
    post_max_size = 100M
    upload_max_filesize = 100M
    date.timezone = Europe/Paris
    
    ; Extensions courantes
    extension=mysqli
    extension=pdo_mysql
    extension=gd
    extension=curl
    extension=mbstring
    extension=zip
    extension=xml
    extension=intl
  '';

  # Configuration PHP 7.4
  environment.etc."php74/php.ini".text = ''
    max_execution_time = 300
    memory_limit = 512M
    post_max_size = 100M
    upload_max_filesize = 100M
    date.timezone = Europe/Paris
    
    extension=mysqli
    extension=pdo_mysql
    extension=gd
    extension=curl
    extension=mbstring
    extension=zip
    extension=xml
  '';

  # Créer le répertoire www automatiquement
  systemd.tmpfiles.rules = [
    "d /home/${config.user}/www 0755 ${config.user} users -"
    "f /home/${config.user}/www/index.php 0644 ${config.user} users - <?php phpinfo(); ?>"
  ];

  # Génération de certificat SSL auto-signé
  security.acme.certs."localhost" = {
    domain = "localhost";
    email = config.gitEmail;
    webroot = "/home/${config.user}/www";
    postRun = "systemctl reload httpd";
  };

  # Ouvrir les ports du firewall
  networking.firewall.allowedTCPPorts = [ 80 443 3306 8080 ];

  # Alias shell pratiques
  environment.shellAliases = {
    # Gestion des services
    laragon-start = "sudo systemctl start httpd nginx mysql phpfpm-www";
    laragon-stop = "sudo systemctl stop httpd nginx mysql phpfpm-www";
    laragon-restart = "sudo systemctl restart httpd nginx mysql phpfpm-www";
    laragon-status = "sudo systemctl status httpd nginx mysql phpfpm-www";
    
    # Logs
    laragon-logs-apache = "sudo journalctl -u httpd -f";
    laragon-logs-nginx = "sudo journalctl -u nginx -f";
    laragon-logs-mysql = "sudo journalctl -u mysql -f";
    
    # Basculer entre PHP 7.4 et 8.2
    php74-switch = "sudo systemctl stop phpfpm-www && export PATH=${pkgs.php74}/bin:$PATH";
    php82-switch = "sudo systemctl stop phpfpm-www && export PATH=${pkgs.php82}/bin:$PATH";
    
    # Outils pratiques
    mysql-console = "mysql -u ${config.user} -p";
    phpmyadmin-url = "echo 'http://localhost/phpmyadmin'";
  };

  # Script de démarrage pratique
  environment.systemPackages = [
    (pkgs.writeScriptBin "laragon-info" ''
      #!${pkgs.bash}/bin/bash
      echo "╔═══════════════════════════════════════╗"
      echo "║   Laragon-like Environment Info       ║"
      echo "╚═══════════════════════════════════════╝"
      echo ""
      echo "📁 Web Root: /home/${config.user}/www"
      echo ""
      echo "🌐 Web Servers:"
      echo "   • Apache: http://localhost (port 80)"
      echo "   • Apache SSL: https://localhost (port 443)"
      echo "   • Nginx: http://localhost:8080"
      echo ""
      echo "🗄️  Database:"
      echo "   • MySQL 5.7: localhost:3306"
      echo "   • User: ${config.user}"
      echo ""
      echo "🐘 PHP Versions:"
      echo "   • Active: $(php -v | head -n1)"
      echo "   • Available: PHP 7.4, PHP 8.2"
      echo ""
      echo "🛠️  Tools:"
      echo "   • PHPMyAdmin: http://localhost/phpmyadmin"
      echo "   • DBeaver: launch with 'dbeaver'"
      echo ""
      echo "📋 Quick Commands:"
      echo "   • laragon-start    : Start all services"
      echo "   • laragon-stop     : Stop all services"
      echo "   • laragon-restart  : Restart all services"
      echo "   • laragon-status   : Check services status"
      echo ""
    '')
  ];

  # Configuration de PHPMyAdmin
  services.httpd.virtualHosts."localhost".extraConfig = lib.mkAfter ''
    Alias /phpmyadmin ${pkgs.phpmyadmin}/share/phpmyadmin
    
    <Directory ${pkgs.phpmyadmin}/share/phpmyadmin>
      DirectoryIndex index.php
      AllowOverride All
      Require all granted
      
      <FilesMatch \.php$>
        SetHandler "proxy:unix:${config.services.phpfpm.pools.www.socket}|fcgi://localhost"
      </FilesMatch>
    </Directory>
  '';

  # Assurer que tous les services démarrent au boot
  systemd.services.httpd.wantedBy = lib.mkForce [ "multi-user.target" ];
  systemd.services.nginx.wantedBy = lib.mkForce [ "multi-user.target" ];
  systemd.services.mysql.wantedBy = lib.mkForce [ "multi-user.target" ];
  systemd.services.phpfpm-www.wantedBy = lib.mkForce [ "multi-user.target" ];
}
