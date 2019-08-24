#!/bin/env python
import salt.client
import salt.config
import sys
import re
#userfile = "/srv/salt/prod/nginx-fz/files/nginx-user.conf"
#slave = ['OsYunWei_cb7225de27_23','OsYunWei_d54f95553d_188']
#appname = "user1"
def roalback_config(minion,conf_file,appname):
  #for minion in minions:
    local1=salt.client.LocalClient()
    #caller = salt.client.Caller()
    #ff=caller.cmd('test.ping')
    #print ff
    dd=local1.cmd(minion,'network.interface_ip',['eno16777736'])
    #print dd
    server1= dd[minion]
    #print server1
    srip = "server"+' '+server1+":"+"8080"+";"+"\n\t\t"
    with open(conf_file,'r') as file1:
      line = file1.read()
      regexp = "upstream.*"+' '+appname+"[^}]*(?=\})"
      pat = re.compile(regexp)
    #pat = re.compile('upstream.* adv1[^}]*(?=\})')
      if pat.findall(line):
        patcheck = re.compile(srip)
        if patcheck.findall(pat.findall(line)[0]):
          print '%s in cluster alreadly' % server1
        #patn = pat.findall(line)[0] + srip
          line = line.replace(patcheck.findall(pat.findall(line)[0])[0],'')
          print line
          with open(conf_file,'w') as file1:
            file1.write(line)
#modfiy_config(slave,userfile,appname)
'''
local = salt.client.LocalClient()
resycle_config = local.cmd('OsYunWei_cb7225de27_23','state.highstate')
'''
