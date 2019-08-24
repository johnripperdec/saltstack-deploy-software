#!/bin/env python
import salt.client
local = salt.client.LocalClient()
print local.cmd('OsYunWei_572497f5af_11','cmd.run',['sh /opt/script/inotify.sh'])
