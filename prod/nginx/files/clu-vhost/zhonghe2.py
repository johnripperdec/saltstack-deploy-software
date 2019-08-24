#!/bin/env python
import os,sys
import hqbbhfun
import testtarbao
import salt.client
import salt.config
import shutil
import testinotify
import inputclusterfun
gzpath = '/opt/package'
appname = 'duobao1'
ino_file = "/srv/salt/prod/inotify-tools/files/inotifyrsync.sh"
svn_url = 'svn://182.148.112.100/DBO/develop/qianduan/duobao/duobao_web'
duobaofile = "/srv/salt/prod/nginx-fz/files/nginx-duobao.conf"
url_port = "8080"
URLFZ = "http://192.168.8.23:80"
MASTER = 'OsYunWei_cb7225de27_23'
username = 'songjian'
password = 'songjian'
svn_server = 'OsYunWei_cb7225de27_23'
rsync_server = 'OsYunWei_572497f5af_11'
desminion = 'OsYunWei_523eaa2a6a_195'
rsync_destdr = '/opt/webbao'
svn_dest = '/opt/tmp2'
package_dest = '/srv/salt/prod/web_duobao/files'
bm = testtarbao.tarbao(gzpath,svn_dest,svn_server,svn_url,username,password,package_dest)
#saltfile = 'salt://web_duobao/files'+"/"+dm+".tar.gz"
saltfile = 'salt://web_duobao/files'+"/"+bm
print saltfile
#destfile = rsync_destdr+"/"+dm+".tar.gz"
destfile = rsync_destdr+"/"+bm
print destfile
local = salt.client.LocalClient()
db = local.cmd('WebDuoBao*','test.ping')
print db
dc = list(db)
if len(dc) == 0:
   print "no minions to state.sls"
else:
   print dc
   for desminion in dc:
       if desminion == '':
          print "minions is null"
          continue
       else:
          print local.cmd(desminion,'state.sls',['env_init','base'])
          print local.cmd(desminion,'state.sls',['rsync.rsyncd-service','prod'])
          testinotify.modfiy_config(desminion,ino_file)
          print local.cmd('OsYunWei_572497f5af_11','state.highstate')
          print local.cmd(rsync_server,'cp.get_file',[saltfile,destfile],kwarg={'saltenv':'prod'})
          #print local.cmd('nginx_duobao','state.sls',['web_duobao.web_duobao','prod'],expr_form = 'nodegroup')
          print local.cmd(desminion,'state.sls',['web_duobao.web_duobao','prod'])
          inputclusterfun.inputcluster(desminion,url_port,URLFZ,duobaofile,appname,MASTER)
          #print local.cmd(desminion,'state.highstate')

