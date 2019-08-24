include:
  - pcre.pcre-install
  - user.www 
ngx-cache-purge:
  file.managed:
    - name: /opt/ngx_cache_purge-2.3.tar.gz
    - source: salt://fastdfs/files/ngx_cache_purge-2.3.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/ngx_cache_purge-2.3.tar.gz
  cmd.run:
    - name: cd /opt && tar zxf ngx_cache_purge-2.3.tar.gz
    - unless: test -d /opt/ngx_cache_purge-2.3
nginx-cache-source:
  file.managed:
    - name: /opt/nginx-1.10.3.tar.gz
    - source: salt://fastdfs/files/nginx-1.10.3.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && tar zxf nginx-1.10.3.tar.gz && cd nginx-1.10.3 &&./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --with-file-aio --with-http_dav_module --with-pcre=/opt/pcre-8.37 --add-module=/opt/ngx_cache_purge-2.3 && make && make install && chown -R www:www /usr/local/nginx
    - unless: test -d /usr/local/nginx
    - require:
      - user: www-user-group
      - file: nginx-cache-source
