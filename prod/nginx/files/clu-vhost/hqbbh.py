#!/bin/env python
import  os,sys
gzpath = '/opt/package/'
banben = []
for gz in os.listdir(gzpath):
    print gz
    #destgz = gzpath+gz
    tempbb = os.path.basename(os.path.splitext(os.path.splitext(gzpath+gz)[0])[0]).split('-')[1]
    banben.append(tempbb)
print banben
print max(banben)

