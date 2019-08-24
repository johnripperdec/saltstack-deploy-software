include:
  - pcre.pcre-install
  - user.www 
fastdfs-module:
  file.managed:
    - name: /opt/fastdfs-nginx-module_v1.16.tar.gz
    - source: salt://fastdfs/files/fastdfs-nginx-module_v1.16.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/fastdfs-nginx-module_v1.16.tar.gz
  cmd.run:
    - name: cd /opt && tar zxf fastdfs-nginx-module_v1.16.tar.gz
    - unless: test -d /opt/fastdfs-nginx-module
nginx-storage-source:
  file.managed:
    - name: /opt/nginx-1.10.3.tar.gz
    - source: salt://fastdfs/files/nginx-1.10.3.tar.gz
    - user: root
    - group: root
    - mode: 755
    - unless: test -f /opt/nginx-1.10.3.tar.gz
  cmd.run:
    - name: cd /opt && tar -zxvf nginx-1.10.3.tar.gz && cd nginx-1.10.3 &&./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --with-file-aio --with-http_dav_module --with-pcre=/opt/pcre-8.37 --add-module=/opt/fastdfs-nginx-module/src && make && make install && chown -R www:www /usr/local/nginx
    - unless: test -d /usr/local/nginx
    - require:
      - user: www-user-group
      - file: nginx-storage-source
