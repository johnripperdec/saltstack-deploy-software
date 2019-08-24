pkg-expect:
  pkg.installed:
    - name: expect
adduser:
  cmd.run:
    - name: useradd dengchao && salt saltminion*' cmd.run echo `mkpasswd` | tee /root/dengchao_pwd.txt | passwd --stdin dengchao && salt saltminion*' cmd.run 'cat /root/root_pwd.txt'
