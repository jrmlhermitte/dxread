# dxread
This repository is the python version of dxread.c, for reading satellite
DX data. See the example in examples for a sample extraction of the
radiance.  pyqtgraph is used as a plotting library but may be easily
replaced by matplotlib. See the results folder for sample result images.

I had originally written these routines in yorick but have not included
the code.

How to run example files (my recommendation but feel free to modify):
1. Run ipython in main folder (nicer for interaction/debugging)
2. Use the magic command to run, for example, type:
	%run examples/pydxread_ex.py

Current examples:
	pydxread_ex.py : First example on how to run, data included
	iradaverage.py : obtain average of iradiance (or time series) over 1 day
	yearaverage.py : obtain yearly average of iradiance.
		NOTE: Needs the data downloaded. First use the commented code to create
		the shell script to download the data. Tried using urllib.urlretrieve for
		downloading but there is a long hangup at the end of each file download
		(not sure why but cannot find bug fix)

Results:
	radiance.png : Sample radiance extracted from one image
	1985-irad-yearavg.png : Radiance averaged over a year

References:

dxread.c : http://isccp.giss.nasa.gov/pub/tables/ISCCP.DXREADC.0.GLOBAL.2003.09.99.9999.GPC

pdf documentation concerning the data structure: http://isccp.giss.nasa.gov/pub/documents/d-doc.pdf
