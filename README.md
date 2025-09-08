Datacenter320
=============

Or simply 320, is a comprehensive software package for managing virtual hosting on Arch Linux. The main feature of Datacenter320 is its predominantly CLI interface for managing everything.

> [!IMPORTANT]
> 320 is in the initial development stage, designed for a specific server configuration, and everything you see is all that has been implemented in it so far.


Requirements (minimal, in theory)
---------------------------------
OS: Arch Linux  
Packages: `php mariadb caddy xfsprogs tinyfilemanager phpmyadmin`  
CPU: 2x2.0GHz amd64  
RAM: 4GB  
HDD: 8GB  
/srv/www: XFS with enabled uquota and gquota  


Installation
------------
1. Ensure that Arch is up-to-date
   ```
   pacman -Syu
   ```
2. Install required packages
    ```
    # pacman -S php mariadb caddy xfsprogs phpmyadmin
    # trizen -S tinyfilemanager
    ```
3. Configure everything
    * [mariadb-secure-installation](https://mariadb.com/docs/server/clients-and-utilities/deployment-tools/mariadb-secure-installation)
    * Add admin.sock
      ```
      ; /etc/php/php-fpm.d/admin.conf
      [admin]
      user = caddy
      group = caddy
      listen = /run/php-fpm/admin.sock
      listen.owner = caddy
      listen.group = caddy
      listen.mode = 0660
      ```
    * Setup Caddyfile
      ```
      # /etc/caddy/Caddyfile
      # Replace .qwa.su with your domain
      pma.qwa.su {
          tls /etc/caddy/certs/fullchain.pem /etc/caddy/certs/key.pem 
          root * /usr/share/webapps/phpMyAdmin
          php_fastcgi unix//run/php-fpm/admin.sock
          file_server
      }
      
      tfm.qwa.su {
          tls /etc/caddy/certs/fullchain.pem /etc/caddy/certs/key.pem 
          root * /usr/share/webapps/tinyfilemanager
          php_fastcgi unix//run/php-fpm/admin.sock
          file_server
      }
      
      * {
          tls /etc/caddy/certs/fullchain.pem /etc/caddy/certs/key.pem 
          root * /srv/www/{host}
          php_fastcgi unix//run/php-fpm/php-fpm.sock {
              index index.php
          }
          file_server
      
          redir /{path}.php{query} 301
          try_files {path} {path}/index.php index.php
      
          handle_errors {
              @404 {
                  expression {http.error.status_code} == 404
              }
              rewrite @404 /404.html
              file_server
          }
      }
      ```
    * Set up ssl...
    There are many ways to obtain a wildcard certificate, but I use Cloudflare (see [cert.sh](cert.sh))


License
=======

[320](320) is distributed under the [MIT License](LICENSE)