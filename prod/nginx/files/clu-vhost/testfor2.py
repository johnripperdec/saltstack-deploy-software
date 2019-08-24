#!/bin/env python
import salt.client
import salt.config
import sys
import re
minions = ['OsYunWei_cb7225de27_23','OsYunWei_d54f95553d_188']
for minion in minions:
  local=salt.client.LocalClient()
  caller = salt.client.Caller()
  ff=caller.cmd('test.ping')
  print ff
  dd=local.cmd(minion,'network.interface_ip',['eno16777736'])
  print dd
  server1= dd[minion]
  print server1
  srip = "server"+' '+server1+":"+"80"+";"+"\n\t\t"
  file1 = open(r'/srv/salt/prod/nginx/files/clu-vhost/nginx-web.conf','r')
  line = file1.read()
  pat = re.compile('upstream.* adv1[^}]*(?=\})')
  if pat.findall(line):
    patcheck = re.compile(srip)
    if patcheck.findall(pat.findall(line)[0]):
      print '%s in cluster alreadly' % server1
      continue
    patn = pat.findall(line)[0] + srip
    line = line.replace(pat.findall(line)[0],patn)
    print line
    file1.close
    file1 = open(r'/srv/salt/prod/nginx/files/clu-vhost/nginx-web.conf','w')
    file1.write(line)
    file1.close
file1.close


