import pydxread as pydx
import pyqtgraph as pg
import numpy as np
from scipy.interpolate import Rbf

class dummy:
    pass

def pos2Grid(x,y,data,xbins=None,ybins=None):
    '''Make a pixellated grid image from a 1d array
        of positions x,y,d. No smoothing, just binning.'''

    if (xbins == None):
	xbins = np.arange(x.min(),x.max()+1)
    if (ybins == None):
	ybins = np.arange(y.min(),y.max()+1)
            
    xd = np.digitize(x,xbins)
    xd -= 1 
	
    yd = np.digitize(y,ybins)
    yd -= 1
	
    (w,) = np.where((xd != 0) & (yd != 0))

    xd = xd[w]
    yd = yd[w]
    data = data[w]
	
    xi,yi = np.array(np.meshgrid(xbins,ybins,indexing='ij'))
    zi = xi*0
    zi[xd,y] = data
    return zi

prefix = "data/ISCCP.DX.0.GOE-7.1991.01.01."
times = np.arange(0,22,3)*100

xbins = np.arange(501)
ybins = np.arange(501)
zi = np.zeros((len(times),501,501))

for i in np.arange(len(times)):
    print "Time # {}".format(times[i])
    filename = "{:s}{:04d}.AES".format(prefix,times[i])
    stdat = pydx.dxread(filename)
    irads = np.array([o.irad for o in stdat.dxs1s])
    zi[i,:,:] = pos2Grid(stdat.x,stdat.y,irads,xbins=xbins,ybins=ybins)

zi = zi[:,:,::-1]
#3d image plots as time series, use scroll bar to cycle through images
pg.image(zi)

#1 day average of cloud cover
zavg = np.average(zi,axis=0)
pg.image(zavg)
