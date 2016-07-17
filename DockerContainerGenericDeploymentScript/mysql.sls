mysql-server:
  pkg.installed
php5-mysql:
  pkg.installed

server_pkgs:
  pkg:
    - installed
    - pkgs:
      - python-dev
    - refresh: True

mysql_python_pkgs:
  pkg.installed:
    - pkgs:
      - libmysqlclient-dev
      - mysql-client
      - python-mysqldb
    - require:
      - pkg: server_pkgs

python-pip:
  pkg:
    - installed
    - refresh: False

mysql:
  pip.installed:
    - require:
      - pkg: python-pip
      - pkg: mysql_python_pkgs

wordpress:
  mysql_user.present:
    - host: localhost
    - password: "root"
    - connection_user: root
    - connection_pass: 
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: "en_US.utf8"

database:
  mysql_database.present:
    - host: localhost
    - connection_user: root
    - connection_pass: 
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: "en_US.utf8"
    - name: wordpress
  mysql_grants.present:
    - host: localhost
    - connection_user: root
    - connection_pass: 
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: "en_US.utf8"
    - grant: all privileges
    - name: wordpress
    - user: wordpress
    - database: "*.*"
