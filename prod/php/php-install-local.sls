include:
  - user.www
php-pkg:
  pkg.installed:
    - names:
      - mysql-community-devel 
      - openssl-devel
      - swig
      - libjpeg-turbo
      - libjpeg-turbo-devel
      - libpng
      - libpng-devel
      - freetype
      - freetype-devel
      - libxml2
      - libxml2-devel
      - zlib
      - zlib-devel
      - libcurl
      - libcurl-devel
php-source:
  file.managed:
    - name: /opt/php-5.6.9.tar.gz
    - source: salt://php/files/php-5.6.9.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && tar zxf php-5.6.9.tar.gz && cd php-5.6.9&&  ./configure --prefix=/usr/local/php-fastcgi --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd --with-mysql=mysqlnd --with-jpeg-dir --with-png-dir --with-zlib --enable-xml  --with-libxml-dir --with-curl --enable-bcmath --enable-shmop --enable-sysvsem  --enable-inline-optimization --enable-mbregex --with-openssl --enable-mbstring --with-gd --enable-gd-native-ttf --with-freetype-dir=/usr/lib64 --with-gettext=/usr/lib64 --enable-sockets --with-xmlrpc --enable-zip --enable-soap --disable-debug --enable-opcache --enable-zip --with-config-file-path=/usr/local/php-fastcgi/etc --enable-fpm --with-fpm-user=www --with-fpm-group=www && make && make install
    - require:
      - file: php-source
      - user: www-user-group
      - pkg: pkg-install
    - unless: test -d /usr/local/php-fastcgi
pdo-plugin:
  cmd.run:
    - name: cd /opt/php-5.6.9/ext/pdo_mysql/ && /usr/local/php-fastcgi/bin/phpize && ./configure --with-php-config=/usr/local/php-fastcgi/bin/php-config &&  make&& make install
    - unless: test -f /usr/local/php-fastcgi/lib/php/extensions/*/pdo_mysql.so
ldap_pkg:
  pkg.installed:
    - names:
      - openldap
      - openldap-devel
  cmd.run:
    - name: cd /opt/php-5.6.9/ext/ldap/ && /usr/local/php-fastcgi/bin/phpize && cp -frp /usr/lib64/libldap* /usr/lib/ && ./configure --with-php-config=/usr/local/php-fastcgi/bin/php-config &&  make&& make install 
    - require:
      - pkg: ldap_pkg
    - unless: test -f /usr/local/php-fastcgi/lib/php/extensions/*/ldap.so
php-ini-config:
  file.managed:
    - name: /usr/local/php-fastcgi/etc/php.ini
    - source: salt://php/files/php.ini-production
    - user: root
    - group: root
    - mode: 644
php-fpm-config:
  file.managed:
    - name: /usr/local/php-fastcgi/etc/php-fpm.conf
    - source: salt://php/files/php-fpm.conf.default
    - user: root
    - group: root
    - mode: 644
php-fpm-init:
  file.managed:
    - name: /etc/init.d/php-fpm
    - source: salt://php/files/php-fpm-init
    - user: www
    - group: www
    - mode: 755
php-logdir:
  file.directory:
    - name: /data
    - user: www
    - group: www
    - unless: test -d /data
  
php-service:
  service.running:
    - name: php-fpm
    - enable: True
    - require:
      - file: php-logdir
    - watch:
      - file: php-fpm-config
      - file: php-ini-config  



