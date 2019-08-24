#!/bin/env python
import os,sys
import re
#gzpath = '/opt/package/'
def maxbanben(gzpath):
    banben = []
    if os.listdir(gzpath) == '':
       return 1
    else: 
       for gz in os.listdir(gzpath):
	   print gz
           regexp = "\d{1,9}"
           pat = re.compile(regexp)
           tempbb = pat.findall(gz)
           print tempbb
	   #tempbb = os.path.basename(os.path.splitext(os.path.splitext(gzpath+gz)[0])[0]).split('-')[1]
	   banben.append(tempbb)
       print banben
       return int(max(banben)[0])+1
#maxbanben(gzpath)
