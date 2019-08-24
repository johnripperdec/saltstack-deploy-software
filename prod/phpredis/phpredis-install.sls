phpredis-source:
  file.managed:
    - name: /opt/phpredis-2.2.7.tgz
    - source: salt://phpredis/files/phpredis-2.2.7.tgz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && tar zxf phpredis-2.2.7.tgz && cd redis-2.2.7 &&/usr/local/php-fastcgi/bin/phpize && ./configure --with-php-config=/usr/local/php-fastcgi/bin/php-config &&  make&& make install
    - unless: test -f /usr/local/php-fastcgi/lib/php/extensions/*/redis.so
    - require:
      - cmd: php-source
phpredis-ini:
  file.append:
    - name: /usr/local/php-fastcgi/etc/php.ini
    - text:
      - extension=redis.so
