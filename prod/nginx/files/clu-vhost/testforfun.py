#!/bin/env python
import salt.client
import salt.config
import sys
import re
conf_file = "/srv/salt/prod/nginx/files/clu-vhost/nginx-web.conf"
minions = ['OsYunWei_cb7225de27_23','OsYunWei_d54f95553d_188']
appname = "adv1"
def modfiy_config(minions,conf_file,appname):
  for minion in minions:
    local1=salt.client.LocalClient()
    caller = salt.client.Caller()
    ff=caller.cmd('test.ping')
    print ff
    dd=local1.cmd(minion,'network.interface_ip',['eno16777736'])
    print dd
    server1= dd[minion]
    print server1
    srip = "server"+' '+server1+":"+"80"+";"+"\n\t\t"
    file1 = open(conf_file,'r')
    line = file1.read()
    regexp = "upstream.*"+' '+appname+"[^}]*(?=\})"
    pat = re.compile(regexp)
    #pat = re.compile('upstream.* adv1[^}]*(?=\})')
    if pat.findall(line):
      patcheck = re.compile(srip)
      if patcheck.findall(pat.findall(line)[0]):
        print '%s in cluster alreadly' % server1
        continue
      patn = pat.findall(line)[0] + srip
      line = line.replace(pat.findall(line)[0],patn)
      print line
      file1.close
      file1 = open(conf_file,'w')
      file1.write(line)
      file1.close
    file1.close
modfiy_config(minions,conf_file,appname)
