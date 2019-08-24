#!/bin/env python
import salt.client
import salt.config
import sys
import re
import random
#userfile = "/srv/salt/prod/nginx-fz/files/nginx-user.conf"
#config_file = "/srv/salt/prod/inotify-tools/files/inotifyrsync.sh"
#minion = 'OsYunWei_523eaa2a6a_195'
#slave = ['OsYunWei_cb7225de27_23','OsYunWei_d54f95553d_188']
#appname = "user1"
def modfiy_config(minion,conf_file):
  #for minion in minions:
    local1=salt.client.LocalClient()
    #caller = salt.client.Caller()
    #ff=caller.cmd('test.ping')
    #print ff
    dd=local1.cmd(minion,'network.interface_ip',['eno16777736'])
    #print dd
    server1= dd[minion]
    print server1
    hostadd = server1.split('.')[3]
    print hostadd
    #srip = "server"+' '+server1+":"+"8080"+";"+"\n\t\t"
    #hostnamen = "host"+str(random.randint(10,2000))
    hostnamen = "host"+hostadd
    print hostnamen
    hostip = hostnamen+"="+server1
    print hostip
    rsyncex = "/usr/bin/rsync -vzrtopg --delete --progress --password-file=/etc/rsync.password $src $user1@$"+hostnamen+"::$dst1"
    print rsyncex
    rsyncrex = "/usr/bin/rsync -vzrtopg --delete --progress --password-file=/etc/rsync.password"+' '+"\$src"+' '+"\$user1@"+hostnamen+"::"+"\$dst1"
    print rsyncrex
    with open(conf_file,'r') as file1:
      line = file1.read()
      print line
      print "dddddd"
      #regexp = "upstream.*"+' '+appname+"[^}]*(?=\})"
      regexp = "host\d+=.*\d+\d"
      pat = re.compile(regexp)
      print pat.findall(line)
    #pat = re.compile('upstream.* adv1[^}]*(?=\})')
    if pat.findall(line):
       print [hostip]
       if hostip in pat.findall(line):
          print '%s in intofy hosts alredly' % server1
       else:
          patn = pat.findall(line)[0]+"\n" + hostip
          print patn
          line = line.replace(pat.findall(line)[0],patn)
          print line
      #file1.close
          with open(conf_file,'w') as file1:
               file1.write(line)
    with open(conf_file,'r') as file1:
      line = file1.read()
      #regexp = "upstream.*"+' '+appname+"[^}]*(?=\})"
      regexp = "/usr/bin/rsync.*dst1"
      pat = re.compile(regexp)
      print pat.findall(line)
    #pat = re.compile('upstream.* adv1[^}]*(?=\})')
    if pat.findall(line):
       if rsyncex in pat.findall(line):
          print '%s tui song in inotify script alreadly' % server1
       else:
          patn = pat.findall(line)[0]+"\n" + rsyncex
          line = line.replace(pat.findall(line)[0],patn)
          print line
      #file1.close
          with open(conf_file,'w') as file1:
               file1.write(line)
#modfiy_config(minion,config_file)
#modfiy_config(slave,userfile,appname)
#local = salt.client.LocalClient()
#resycle_config = local.cmd('OsYunWei_cb7225de27_23','state.highstate')
