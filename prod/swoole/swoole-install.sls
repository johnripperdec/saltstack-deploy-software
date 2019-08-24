swoole-source:
  file.managed:
    - name: /opt/swoole-src.tar.gz
    - source: salt://swoole/files/swoole-src.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && tar zxf swoole-src.tar.gz && cd swoole-src && /usr/local/php-fastcgi/bin/phpize && ./configure --with-php-config=/usr/local/php-fastcgi/bin/php-config &&  make&& make install
    - unless: test -f /usr/local/php-fastcgi/lib/php/extensions/*/swoole.so
    - require:
      - cmd: php-source
      - file: swoole-source
swoole-ini:
  file.append:
    - name: /usr/local/php-fastcgi/etc/php.ini
    - text:
      - extension=swoole.so
