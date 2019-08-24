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
aa = local.cmd('nginx_duobao','state.sls',['updateweb.updateweb','prod'],expr_form = 'nodegroup')
print aa
