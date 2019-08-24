#!/bin/evn python
import salt.client
local = salt.client.LocalClient()
dd2 = local.cmd('nginx_duobao','test.ping',expr_form = 'nodegroup')
print dd2
