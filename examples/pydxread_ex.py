import pydxread as pydx
import pyqtgraph as pg
import numpy as np
from scipy.interpolate import Rbf

filename = "data/ISCCP.DX.0.MET-7.2002.01.02.1200.EUM"
#filename = "data/ISCCP.DX.0.GOE-7.1991.01.01.0000.AES"
#filename = "data/ISCCP.DX.0.GOE-7.1991.01.01.1200.AES"
#filename = "data/ISCCP.DX.0.NOA-10A.1991.01.01.0000.NOM"
#filename = "data/ISCCP.DX.0.MET-7.2004.01.01.0300.EUM"
#filename = "data/ISCCP.DX.0.GOE-7.1991.01.01.1500.AES"
#filename = "data/ISCCP.DX.0.GOE-6.1985.01.01.0300.CSU"
#this is daytime data so visible radiance may be measured
#filename = "data/ISCCP.DX.0.GOE-7.1991.01.01.1800.AES"


stdat = pydx.dxread(filename)
irads = np.array([o.irad for o in stdat.dxs1s])
bxshors = np.array([o.bxshor for o in stdat.dxs1s])
nodays = np.array([o.noday for o in stdat.dxs1s])
#only set if day (so noday==0)
vrads = np.zeros(len(irads))
vcslogs = np.zeros(len(irads))
vrads = np.array([o.vrad for o in stdat.dxs2s])
vcslogs = np.array([o.vcslog for o in stdat.dxs2s])

x = stdat.x
y = stdat.y

xbins = np.arange(x.min(),x.max()+1)
xd = np.digitize(x,xbins)
xd -= 1 

ybins = np.arange(y.min(),y.max()+1)
yd = np.digitize(y,ybins)
yd -= 1
yd = yd[::-1]#reverse order

(w,) = np.where((xd != 0) & (yd != 0))
xd = xd[w]
yd = yd[w]
irads = irads[w]
vrads = vrads[w]
nodays = nodays[w]
bxshors = bxshors[w]
vcslogs = vcslogs[w]

xi,yi     = np.array(np.meshgrid(xbins,ybins,indexing='ij'))
IRADS     = np.zeros(xi.shape)
BXSHORS   = np.zeros(xi.shape)
NODAYS    = np.zeros(xi.shape)
VRADS     = np.zeros(xi.shape)
VCSLOGS   = np.zeros(xi.shape)
IRADS[xd,yd]   = irads   #IR radiance (day and night)
BXSHORS[xd,yd] = bxshors #shoreline
NODAYS[xd,yd]  = nodays  #night time
VRADS[xd,yd]   = vrads
VCSLOGS[xd,yd] = vcslogs

pg.image(IRADS,title="IR Radiance")
pg.image(BXSHORS,title="Shorelines")
pg.image(NODAYS,title="Night time")
pg.image(VRADS,title="Visible Radiance")
pg.image(VCSLOGS,title="Cloudiness")
