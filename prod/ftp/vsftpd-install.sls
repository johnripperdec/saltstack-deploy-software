vsftpd-pkg:
  pkg.installed:
    - name: vsftpd
vsftpd-config:
  file.managed:
    - name: /etc/vsftpd/vsftpd.conf
    - source: salt://ftp/files/vsftpd.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: vsftpd-pkg
vsftpd-userfile:
  file.managed:
    - name: /etc/vsftpd/user_list
    - source: salt://ftp/files/user_list
    - user: root
    - group: root
    - mode: 644

vsftpd-chrootfile:
  file.managed:
    - name: /etc/vsftpd/chroot_list
    - source: salt://ftp/files/chroot_list
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: vsftpd
    - enable: True
    - require:
      - file: vsftpd-config
      - file: vsftpd-userfile
      - file: vsftpd-chrootfile
