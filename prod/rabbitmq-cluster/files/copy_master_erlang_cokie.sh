#!/usr/bin/expect 
#set date [exec date -d yesterday "+%Y-%m-%d"]
#exp_internal 1
spawn /usr/bin/scp /var/lib/rabbitmq/.erlang.cookie  root@10.10.24.19://srv/salt/prod/rabbitmq-cluster/files/
set timeout 300
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "adm*123\r" }
}
expect eof
exit
