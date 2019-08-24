pcre-source:
  file.managed:
    - name: /opt/pcre-8.37.tar.gz
    - source: salt://pcre/files/pcre-8.37.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && tar zxf pcre-8.37.tar.gz && cd pcre-8.37 && ./configure --prefix=/usr/local/pcre && make && make install
    - unless: test -d /usr/local/pcre
    - require:
      - file: pcre-source
