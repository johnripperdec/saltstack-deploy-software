#!/bin/evn python
import salt.client
import salt.config
import sys
import re
import time
import pycurl
import os
import testforfunuser
import testforfunuserdel
import pycurlcheck
userfile = "/srv/salt/prod/nginx-fz/files/nginx-user.conf"
webfile = "/srv/salt/prod/nginx-fz/files/nginx-web.conf"
duobaofile = "/srv/salt/prod/nginx-fz/files/nginx-duobao.conf"
appname1 = "user1"
appname2 = "web1"
appname3 = "duobao1"
local = salt.client.LocalClient()
URLFZ = "http://192.168.8.23:80"
MASTER = 'OsYunWei_cb7225de27_23'
#db = local.cmd(MASTER,'pillar.get',['pillar.get master:nodegroups:nginx_duobao'])
local.cmd('nginx_duobao','state.highstate',expr_form = 'nodegroup')
db = local.cmd('nginx_duobao','test.ping',expr_form = 'nodegroup')
dc = list(db)
for node in dc:
    local1=salt.client.LocalClient()
    dd=local1.cmd(node,'network.interface_ip',['eno16777736'])
    servernode = dd[node]
    URL = "http://"+servernode+":8080"
    CoDe = pycurlcheck.pycurlcheck(URL)
    if CoDe == 200:
       testforfunuser.modfiy_config(node,duobaofile,appname3)
       testforfunuser.modfiy_config(node,userfile,appname1)
       testforfunuser.modfiy_config(node,webfile,appname2)
       resycle_config = local.cmd(MASTER,'state.highstate')
       CoDe = pycurlcheck.pycurlcheck(URLFZ)
       if CoDe != 200:
          testforfunuserdel.roalback_config(node,duobaofile,appname3)
          testforfunuserdel.roalback_config(node,userfile,appname1)
          testforfunuserdel.roalback_config(node,webfile,appname2)
          resycle_config = local.cmd(MASTER,'state.highstate')
    else:
       continue
