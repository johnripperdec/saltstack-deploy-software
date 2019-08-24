#!/bin/env python
import os,sys
import hqbbhfun
import salt.client
import salt.config
import shutil
import testinotify
gzpath = '/opt/package'
appname = 'duobao'
ino_file = "/srv/salt/prod/inotify-tools/files/inotifyrsync.sh"
svn_url = 'svn://182.148.112.100/DBO/develop/qianduan/duobao/duobao_web'
username = 'songjian'
password = 'songjian'
svn_server = 'OsYunWei_cb7225de27_23'
rsync_server = 'OsYunWei_572497f5af_11'
desminion = 'OsYunWei_523eaa2a6a_195'
rsync_destdr = '/opt/webbao'
svn_dest = '/opt/tmp2'
package_dest = '/srv/salt/prod/web_duobao/files'
maxpa = hqbbhfun.maxbanben(gzpath)
print maxpa
duobao_web = appname+"_"+str(maxpa)
print duobao_web
local = salt.client.LocalClient()
if os.listdir(svn_dest)[0] != '':
   #shutil.rmtree('/mnt/dd')
   os.system('rm -rf /opt/tmp2/*')
local.cmd(svn_server,'svn.checkout',[svn_dest,svn_url],kwarg={'username':username,'password':password})
db = svn_dest+"/"+os.listdir(svn_dest)[0]
dn = svn_dest+"/"+os.listdir(svn_dest)[0]+"_"+str(maxpa)
dm = os.listdir(svn_dest)[0]+"_"+str(maxpa)
os.renames(db,dn)
svnyc = dn+"/"+".svn"
shutil.rmtree(svnyc)
paname = package_dest+"/"+dm+".tar.gz"
print local.cmd(svn_server,'archive.tar',['-czvf',paname,dm],kwarg={'cwd':svn_dest})
saltfile = 'salt://web_duobao/files'+"/"+dm+".tar.gz"
print saltfile
destfile = rsync_destdr+"/"+dm+".tar.gz"
print local.cmd(desminion,'state.sls',['rsync.rsyncd-service','prod'])
testinotify.modfiy_config(desminion,ino_file)
print local.cmd('OsYunWei_572497f5af_11','state.highstate')
print local.cmd(rsync_server,'cp.get_file',[saltfile,destfile],kwarg={'saltenv':'prod'})
print local.cmd('nginx_duobao','state.sls',['web_duobao.web_duobao','prod'],expr_form = 'nodegroup')
print local.cmd(desminion,'state.highstate')

'''
#db = svn_dest+"/"+os.listdir(svn_dest)[0]
db = svn_dest+"/"+os.listdir(svn_dest)[0]
print db
dn = svn_dest+"/"+os.listdir(svn_dest)[0]+"_"+str(maxpa)
dm = os.listdir(svn_dest)[0]+"_"+str(maxpa)
print "cccccccccccccc"
print dn
if os.listdir(svn_dest)[0] == dm:
   os.rmdir(os.listdir(svn_dest)[0])
os.renames(db,dn)
paname = package_dest+"/"+os.listdir(svn_dest)[0]+"_"+".zip"
print local.cmd(svn_server,'archive.cmd_zip',[paname,dm],kwarg={'cwd':svn_dest})
paichu = dm+"/"+".svn"
print local.cmd(svn_server,'archive.cmd_unzip',[paname,package_dest],kwarg={'excludes':paichu})
'''
