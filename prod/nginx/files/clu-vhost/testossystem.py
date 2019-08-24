#!/bin/python
import os,sys
svn_dest = '/opt/tmp2'
if os.listdir(svn_dest)[0] != '':
   command = "rm -rf"+' '+svn_dest+"/*"
   print command
   os.system(command)
