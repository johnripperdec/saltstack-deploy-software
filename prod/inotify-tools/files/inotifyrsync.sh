#!/bin/bash
host1=192.168.147.209
host194=192.168.8.194
host196=192.168.8.196
host195=192.168.8.195
host2=192.168.8.23
src=/opt/webbao/
dst1=web_jiaotong
#dst2=web2
#dst3=web3
user1=backuser
#user2=web3user
#user3=web3user
/usr/local/inotify-tools/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f%e' -e modify,delete,create,attrib  $src \
| while read files
        do
/usr/bin/rsync -vzrtopg --delete --progress --password-file=/etc/rsync.password $src $user1@$host1::$dst1
#/usr/bin/rsync -vzrtopg --delete --progress --password-file=/etc/rsync.password $src $user1@$host194::$dst1
#/usr/bin/rsync -vzrtopg --delete --progress --password-file=/etc/rsync.password $src $user1@$host196::$dst1
#/usr/bin/rsync -vzrtopg --delete --progress --password-file=/etc/rsync.password $src $user1@$host195::$dst1
#  /usr/bin/rsync -vzrtopg --delete --progress --password-file=/etc/rsync.password  $src $user1@$host2::$dst1
                echo "${files} was rsynced" >>/tmp/rsync.log 2>&1
         done
