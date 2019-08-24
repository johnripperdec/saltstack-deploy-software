#!/bin/bash
L1=`ps -elf| pgrep inotify |wc -l`
if [ $L1 == 0 ]
then
sh /opt/script/inotifyrsync.sh &  
L2=`ps -elf| pgrep inotify |wc -l`
if [ $L2 != 0 ]
then
echo "qi dong wancheng"
fi
else
ps -elf| pgrep inotify |xargs kill -9
sh /opt/script/inotifyrsync.sh &
L2=`ps -elf| pgrep inotify |wc -l`
if [ $L2 != 0 ]
then
echo "chong qi wan cheng"
fi
fi
