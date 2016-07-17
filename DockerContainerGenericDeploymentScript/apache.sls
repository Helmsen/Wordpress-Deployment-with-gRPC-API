packages:
   pkg.installed:
    - pkgs:
      - apache2 
      - libapache2-mod-php5 
      - php5 
      - php5-mysql
      - php5-gd 
      - libssh2-php

service apache2 start:
  cmd.run
