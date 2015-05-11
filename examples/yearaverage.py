#NOTE: This one downloads from the ISCCP database!
#I don't recommend running this but it's a good template
# for scripts that need to download data
import datetime
import time
import pydxread
import numpy as np
import gzip
import os
import pyqtgraph as pg
from examples.pos2Grid import pos2Grid

#I guess just download all files
#The urllib library hangs and is slow to download. Generate a shell 
# command to download files first instead
#Sleep 2 hours just added this because I'm waiting for downloads
# to finish!
time.sleep(7200)

#from http://tudorbarbu.ninja/iterate-thru-dates-in-python/
#uses generators via the yield function
urlprefix = "ftp://eclipse.ncdc.noaa.gov/pub/isccp/dx/1985/GOE-6/"
start_date = datetime.date( year = 1985, month = 1, day = 1)
end_date   = datetime.date( year = 1985, month = 12, day = 31)

def daterange( start_date, end_date ):
    for n in range( ( end_date - start_date ).days + 1 ):
        yield start_date + datetime.timedelta( n )

hours = range(0,24,3)

xbins = np.arange(501)
ybins = np.arange(501)
zi = np.zeros((501,501))
counts = np.zeros((501,501))

#To write the script, uncomment this(then run script in folder you want to 
#put files in):
'''
f = open("dlscript.sh","w")

for d in daterange(start_date, end_date):
   for hr in hours:
       filename = "ISCCP.DX.0.GOE-6.{:4d}.{:02d}.{:02d}.{:04d}.CSU.gz".format(d.year,d.month,d.day,hr*100)
       urlpath = "{}{}".format(urlprefix,filename)
       filepath = "data/1985/{}".format(filename)
       print "Analyzing {}...".format(filename)
       myStr = "wget {}\n".format(urlpath)
        f.write(myStr)

f.close()
'''


for d in daterange(start_date, end_date):
    for hr in hours:
        filename = "ISCCP.DX.0.GOE-6.{:4d}.{:02d}.{:02d}.{:04d}.CSU.gz".format(d.year,d.month,d.day,hr*100)
        urlpath = "{}{}".format(urlprefix,filename)
        filepath = "data/1985/{}".format(filename)
        print "Analyzing {}...".format(filename)
        if(os.path.isfile(filepath)):
            stdat = pydxread.dxread(filepath,gz=1)
            irads = np.array([o.irad for o in stdat.dxs1s])
            zd,xd,yd = pos2Grid(stdat.x,stdat.y,irads,xbins=xbins,ybins=ybins)
            counts[xd,yd] += 1
            zi += zd

w = np.where(counts.flat != 0)
zi.flat[w] = zi.flat[w]/counts.flat[w]
zi = zi[:,::-1]

pg.image(zi)

