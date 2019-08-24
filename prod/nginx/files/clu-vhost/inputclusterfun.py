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
'''
#userfile = "/srv/salt/prod/nginx-fz/files/nginx-user.conf"
#webfile = "/srv/salt/prod/nginx-fz/files/nginx-web.conf"
duobaofile = "/srv/salt/prod/nginx-fz/files/nginx-duobao.conf"
#appname1 = "user1"
#appname2 = "web1"
appname = "duobao1"
local = salt.client.LocalClient()
URLFZ = "http://192.168.8.23:80"
MASTER = 'OsYunWei_cb7225de27_23'
#db = local.cmd(MASTER,'pillar.get',['pillar.get master:nodegroups:nginx_duobao'])

#local.cmd('nginx_duobao','state.highstate',expr_form = 'nodegroup')
db = local.cmd('WebDuoBao*','test.ping')
dc = list(db)
print db
print dc
url_port = "8080"
'''
def inputcluster(node,url_port,URLFZ,duobaofile,appname,MASTER):
    local=salt.client.LocalClient()
    dd=local.cmd(node,'network.interface_ip',['eno16777736'])
    servernode = dd[node]
    URL = "http://"+servernode+":"+url_port
    CoDe = pycurlcheck.pycurlcheck(URL)
    if CoDe == 200:
       testforfunuser.modfiy_config(node,duobaofile,appname)
       local.cmd(MASTER,'state.highstate')
       CoDe = pycurlcheck.pycurlcheck(URLFZ)
       if CoDe != 200:
          testforfunuserdel.roalback_config(node,duobaofile,appname)
          #resycle_config = local.cmd(MASTER,'state.highstate')
          local.cmd(MASTER,'state.highstate')
#for node in dc:
#    inputcluster(node,url_port,URLFZ,duobaofile,appname,MASTER)
