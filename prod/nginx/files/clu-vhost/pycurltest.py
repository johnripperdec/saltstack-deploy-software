#!/bin/env python
import os,sys
import time
import sys
import pycurl

URL="http://www.6lapp.com"
c = pycurl.Curl()
c.setopt(pycurl.URL, URL)
c.setopt(pycurl.CONNECTTIMEOUT, 5)
c.setopt(pycurl.TIMEOUT, 5)
c.setopt(pycurl.FORBID_REUSE, 1)
c.setopt(pycurl.MAXREDIRS, 1)
c.setopt(pycurl.NOPROGRESS, 1)
c.setopt(pycurl.DNS_CACHE_TIMEOUT,30)
indexfile = open(os.path.dirname(os.path.realpath(__file__))+"/content.txt", "wb")
c.setopt(pycurl.WRITEHEADER, indexfile)
c.setopt(pycurl.WRITEDATA, indexfile)
try:
    c.perform()
except Exception,e:
    print "connecion error:"+str(e)
    indexfile.close()
    c.close()
    sys.exit()

NAMELOOKUP_TIME =  c.getinfo(c.NAMELOOKUP_TIME)
CONNECT_TIME =  c.getinfo(c.CONNECT_TIME)
PRETRANSFER_TIME =   c.getinfo(c.PRETRANSFER_TIME)
STARTTRANSFER_TIME = c.getinfo(c.STARTTRANSFER_TIME)
TOTAL_TIME = c.getinfo(c.TOTAL_TIME)
HTTP_CODE =  c.getinfo(c.HTTP_CODE)
SIZE_DOWNLOAD =  c.getinfo(c.SIZE_DOWNLOAD)
HEADER_SIZE = c.getinfo(c.HEADER_SIZE)
SPEED_DOWNLOAD=c.getinfo(c.SPEED_DOWNLOAD)
print "HTTPCODE: %s" %(HTTP_CODE)
print "DNSLOOK_TIME:%.2f ms" %(NAMELOOKUP_TIME*1000)
print "CONNECT_TIME:%.2f ms" %(CONNECT_TIME*1000)
print "PRETRANSFER_TIME:%.2f ms" %(PRETRANSFER_TIME*1000)
print "STARTTRANSFER_TIME:%.2f ms" %(STARTTRANSFER_TIME*1000)
print "TOTAL_TIME:%.2f ms" %(TOTAL_TIME*1000)
print "SIZE_DOWNLOAD:%d bytes/s" %(SIZE_DOWNLOAD)
print "HEADER_SIZE:%d byte" %(HEADER_SIZE)
print "SPEED_DOWNLOAD:%d bytes/s" %(SPEED_DOWNLOAD)
indexfile.close()
c.close()
