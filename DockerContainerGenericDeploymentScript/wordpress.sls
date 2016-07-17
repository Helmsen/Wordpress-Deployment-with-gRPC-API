get-wordpress:
  cmd.run:
    - name: wget http://wordpress.org/latest.tar.gz -P /tmp/

create-apache-folder:
  cmd.run:
    - name: mkdir /var/www/html/FAPRA-TEST/

extract-wordpress:
  cmd.run:
    - name: tar xzvf /tmp/latest.tar.gz -C /var/www/html/FAPRA-TEST/

delete-tar:
  cmd.run:
    - name: rm /tmp/latest.tar.gz
