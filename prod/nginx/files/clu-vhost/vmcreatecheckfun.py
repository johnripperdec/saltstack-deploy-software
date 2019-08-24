#!/bin/env python
import psutil
import time
import os,sys
import salt.client
import salt.config
local = salt.client.LocalClient()
#minionduobao =  local.cmd('OsYunWei_a682364635*','test.ping')
#wuliji = local.cmd('wuliji*','test.ping')
def vmcreate(minionduobao,wuliji):
   duobaoli = list(minionduobao)
   if len(duobaoli) == 0:
      print "no duobao minion is running"
   else:
      for swapck in duobaoli:
          swapused = local.cmd(swapck,'cmd.run',['psutil.swap_memory().used'])
          if swapused > 2000:
	     time.sleep(20)
	     swapused = local.cmd(swapck,'cmd.run',['psutil.swap_memory().used'])
	     if swapused > 2000:
	        #db = local.cmd('wuliji*','test.ping')
		dc = list(wuliji)
		i = 0
		countwlj = len(dc)
		for serwl in dc:
		    dd = local.cmd(serwl,'cmd.run',['psutil.virtual_memory().available'])
		    if dd > 8*1024*1024*1024:
		       local.cmd(serwl,'state.sls',['virt-auto-remote-liulianweb02.kvm-install-remote','prod'])
		       break
		    else:
		       i +=1
		       if i < countwlj:
			  continue
		       else:
			   print "no wuliji available"
			   break
