#!/bin/bash
yum -y update 
yum -y install httpd 
systemctl start httpd.service      
systemctl enable httpd.service
systemctl restart httpd.service
yum -y install epel-release
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
yum -y update
yum -y install php  php-mysqli php-xml php-xmlrpc php-gd php-intl php-mbstring php-soap php-zip php-opcache php-cli php-pgsql php-pdo php-fileinfo php-curl php-common php-fpm php-redis
systemctl restart httpd.service
yum -y install wget
wget https://download.moodle.org/download.php/direct/stable36/moodle-latest-36.tgz
rm -rf /var/www/html/
tar -zxvf moodle-latest-36.tgz -C /var/www/
mv /var/www/moodle /var/www/html
setsebool httpd_can_network_connect true
IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
sleep 30;
/usr/bin/php /var/www/html/admin/cli/install.php --wwwroot=http://${elb_endpoint}/ --dataroot=/var/moodledata --dbtype=mysqli --dbhost=${databases_ip} --dbport=3306 --dbname=${db_name} --dbuser=${db_user_name} --dbpass=${db_pass} --fullname="Moodle" --adminpass=1Qaz2wsx$ --adminemail=admin@gmail.com --shortname="Moodle" --non-interactive --agree-license
chmod a+r /var/www/html/config.php
chcon -R -t httpd_sys_rw_content_t /var/moodledata
systemctl restart httpd.service
rm /var/www/html/config.php
sudo cat <<EOF | sudo tee -a /var/www/html/config.php
<?php  // Moodle configuration file

unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();

\$CFG->dbtype    = 'mysqli';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = '${databases_ip}';
\$CFG->dbname    = '${db_name}';
\$CFG->dbuser    = '${db_user_name}';
\$CFG->dbpass    = '${db_pass}';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array (
    'dbpersist' => 0,
    'dbport' => '',
    'dbsocket' => '',
    'dbcollation' => 'utf8_general_ci',
  );

\$CFG->wwwroot   = 'http://${elb_endpoint}';
\$CFG->dataroot  = '/var/moodledata';
\$CFG->admin     = 'admin';
\$CFG->session_handler_class = '\core\session\redis';
\$CFG->session_redis_host = '${redis_endpoint}';
\$CFG->session_redis_port = 6379;  // Optional.
\$CFG->session_redis_database = 0;  // Optional, default is db 0.
\$CFG->session_redis_prefix = ''; // Optional, default is don't set one.
\$CFG->session_redis_acquire_lock_timeout = 120;
\$CFG->session_redis_lock_expire = 7200;
\$CFG->directorypermissions = 02777;

require_once(__DIR__ . '/lib/setup.php');

