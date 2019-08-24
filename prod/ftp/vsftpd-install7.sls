vsftpd7-pkg:
  pkg.installed:
    - name: vsftpd
ftp-service:
  service.running:
    - name: vsftpd
    - enable: True
