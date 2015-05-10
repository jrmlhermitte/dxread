import pydxread as pydx
import pyqtgraph as pg
import numpy as np
from scipy.interpolate import Rbf

#filename = "data/ISCCP.DX.0.MET-7.2002.01.02.1200.EUM"
#filename = "data/ISCCP.DX.0.GOE-7.1991.01.01.0000.AES"
#filename = "data/ISCCP.DX.0.GOE-7.1991.01.01.1200.AES"
#filename = "data/ISCCP.DX.0.NOA-10A.1991.01.01.0000.NOM"
filename = "data/ISCCP.DX.0.GOE-7.1991.01.01.1500.AES"


stdat = pydx.dxread(filename)
irads = np.array([o.irad for o in stdat.dxs1s])
bxshors = np.array([o.bxshor for o in stdat.dxs1s])

x = stdat.x
y = stdat.y

xbins = np.arange(x.min(),x.max()+1)
xd = np.digitize(x,xbins)
xd -= 1 

ybins = np.arange(y.min(),y.max()+1)
yd = np.digitize(y,ybins)
yd -= 1

(w,) = np.where((xd != 0) & (yd != 0))
xd = xd[w]
yd = yd[w]
irads = irads[w]
#bxshors = bxshors[w]

xi,yi = np.array(np.meshgrid(xbins,ybins,indexing='ij'))
zi = xi*0
zi[xd,yd] = irads
#zi[xd,yd] = bxshors
zi = zi[:,::-1]
#rbf = Rbf(x, y, irads,function='linear')
#zi = rbf(xi, yi)

pg.image(zi)
