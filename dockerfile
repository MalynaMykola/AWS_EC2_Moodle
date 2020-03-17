FROM centos:7

RUN yum -y update
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
    rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm; \
    yum-config-manager --enable remi-php72
RUN yum -y install --nogpgcheck \
    epel-release \
    yum-utils \
    wget \
    git \
    nano
RUN yum -y install \
    php \
    php-bcmath \
    php-cli \
    php-curl \
    php-devel \
    php-gd \
    php-fpm \
    php-imagick \
    php-intl \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-opcache --nogpgcheck \
    php-pdo \
    php-posix \
    php-xml \
    php-zip
RUN php -v
RUN yum -y install httpd
RUN wget https://download.moodle.org/download.php/direct/stable36/moodle-latest-36.tgz
RUN tar -zxvf moodle-latest-36.tgz
RUN cp -R moodle /var/www/html
#CMD ["setsebool", "httpd_can_network_connect", "true"]
RUN /usr/bin/php /var/www/html/moodle/admin/cli/install.php --wwwroot=http://35.202.25.55/moodle --dataroot=/var/m$
RUN chmod a+r /var/www/html/moodle/config.php
RUN chcon -R -t httpd_sys_rw_content_t /var/moodledata

EXPOSE 80
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
