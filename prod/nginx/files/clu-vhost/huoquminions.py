#!/bin/evn python
import salt.client
import salt.config
import sys
import os
local = salt.client.LocalClient()
db = local.cmd('OsYunWei*','test.ping')
print db
dc = list(db)
print dc
print local.cmd('OsYunWei_a682364635_12','state.sls',['env_init','base'])
