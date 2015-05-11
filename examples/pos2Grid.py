import numpy as np
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
    zi[xd,yd] = data
    return zi,xd,yd
