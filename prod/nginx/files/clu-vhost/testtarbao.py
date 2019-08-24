#!/bin/env python
import os,sys
import hqbbhfun
import salt.client
import salt.config
import shutil
import testinotify
'''
gzpath = '/opt/package'
#appname = 'duobao'
svn_url = 'svn://182.148.112.100/DBO/develop/qianduan/duobao/duobao_web'
username = 'songjian'
password = 'songjian'
svn_server = 'OsYunWei_cb7225de27_23'
svn_dest = '/opt/tmp2'
package_dest = '/srv/salt/prod/web_duobao/files'
'''
def tarbao(gzpath,svn_dest,svn_server,svn_url,username,password,package_dest):
    maxpa = hqbbhfun.maxbanben(gzpath)
    print maxpa
    #duobao_web = appname+"_"+str(maxpa)
    #print duobao_web 
    local = salt.client.LocalClient()
    if os.listdir(svn_dest) != '':
       print os.listdir(svn_dest)
       command = "rm -rf"+' '+svn_dest+"/*"
       #shutil.rmtree('/mnt/dd')
       os.system(command)
    local.cmd(svn_server,'svn.checkout',[svn_dest,svn_url],kwarg={'username':username,'password':password})
    db = svn_dest+"/"+os.listdir(svn_dest)[0]
    dn = svn_dest+"/"+os.listdir(svn_dest)[0]+"_"+str(maxpa)
    dm = os.listdir(svn_dest)[0]+"_"+str(maxpa)
    bm = dm+".tar.gz"
    os.renames(db,dn)
    svnyc = dn+"/"+".svn"
    shutil.rmtree(svnyc)
    paname = package_dest+"/"+bm
    print local.cmd(svn_server,'archive.tar',['-czvf',paname,dm],kwarg={'cwd':svn_dest})
    print "%s is tar wan cheng " % bm
    return bm
#bm = tarbao(gzpath,svn_dest,svn_server,svn_url,username,password,package_dest)
#print bm
