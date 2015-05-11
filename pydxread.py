import numpy as np
import os
import struct
import gzip

#from http://stackoverflow.com/questions/1704458/get-uncompressed-size-of-a-gz-file-in-python
def getuncompressedsize(filename):
    with open(filename) as f:
        f.seek(-4, 2)
        return struct.unpack('I', f.read(4))[0]

class DXS1:
    '''The S1 data set for weather. 5 bytes long'''
    def __init__(self,br):
        '''Takes a 5 byte record and converts it
            to the S1 data. NOTE: for each bit, you count
                from highest to lowest order. So noday is actually 
                the first element from the left (so 2^8).
                I could have used shift operators but I feel the 
                brute force notation is more readable for this purpose (and
                    faster). a & 0b1000000 is equivalent to:
                    (a >> 7 & 0b1)
                noday  :  1;
                bxshor :  1;
                lndwtr :  1;
                hitopo :  1;
                snoice :  2;
                timspa :  2;
                icslog :  5;
                bxithr :  3;
                mue    :  8;
                irad   :  8;
                bxicsr :  8;
                '''
        self.noday  = br[0] & 0b10000000
        self.bxshor = br[0] & 0b01000000
        self.lndwtr = br[0] & 0b00100000
        self.hitopo = br[0] & 0b00010000
        self.snoice = br[0] & 0b00001000
        self.timspa = br[0] & 0b00000011
        self.isclog = br[1] & 0b11111000
        self.bxithr = br[1] & 0b00000111
        self.mue    = br[2]
        self.irad   = br[3]
        self.bxicsr = br[4]

class DXADD1:
    '''The DXadd1 data: number of channels number bytes.'''
    def __init__(self,br):
        self.arad = np.array([int(bt) for bt in br])

class DXS2:
    '''The DXS2 data. 5 bytes.
        glint  :  1;
        vcslog :  4;
        bxvthr :  3;
        mu0    :  8;
        phi    :  8;
        vrad   :  8;
        bxvcsr :  8;
        '''
    def __init__(self,br):
        self.glint  = br[0] & 0b10000000
        self.vcslog = br[0] & 0b01111000
        self.bxvthr = br[0] & 0b00000111
        self.mu0    = br[1]
        self.phi    = br[2]
        self.vrad   = br[3]
        self.bxvcsr = br[4]

class DXS3:
    ''' The DXS3 data. 7 bytes
         daynit :  1;
         ithr   :  3;
         vthr   :  3;
         shore  :  1;
         iret   :  4;
         icsret :  4;
         icsrad :  8;
         itmp   :  8;
         iprs   :  8;
         icstmp :  8;
         icsprs :  8;
    '''
    def __init__(self,br):
        self.daynit = br[0] & 0b10000000
        self.ithr   = br[0] & 0b01110000
        self.vthr   = br[0] & 0b00001110
        self.shore  = br[0] & 0b00000001
        self.iret   = br[1] & 0b11110000
        self.icsret = br[1] & 0b00001111
        self.itmp   = br[2]
        self.iprs   = br[3]
        self.icstmp = br[4]
        self.icsprs = br[5]

class DXADD3:
    '''The DXADD3 data. 3 bytes.
        nref   :  8;
        nthr   :  8;
        ncsref :  8;
        '''
    def __init__(self,br):
        self.nref   = br[0]
        self.nthr   = br[1]
        self.ncsref = br[2]

class DXS4:
    '''The DXS4 data. 9 bytes.
        vret   :  4;
        vcsret :  4;
        vcsrad :  8;
        valbta :  8;
        vcsalb :  8;
        vtmp   :  8;
        vprs   :  8;
        vtauic :  8;
        vtmpic :  8;
        vprsic :  8;
'''
    def __init__(self,br):
        self.vret   = br[0] & 0b11110000
        self.vcsret = br[0] & 0b00001111
        self.vcsrad = br[1]
        self.valbta = br[2]
        self.vcsalb = br[3]
        self.vtmp   = br[4]
        self.vprs   = br[5]
        self.vtauic = br[6]
        self.vtmpic = br[7]
        self.vprsic = br[8]

class satData:
    ''' Satellite data object.'''
    pass

def dxread(filename,gz=None):
    ''' Quick utility to read weather data.
        Returns a weather object. NOTE: Bytes are stored
        in a big endian format. '''
    if(gz == None):
        filesize = os.path.getsize(filename)
    else:
        #Only works for files < 2GB!
        filesize = getuncompressedsize(filename)
    RECSIZE = 384*80#number of bytes in a record
    numrecs = filesize/RECSIZE

    satdat = satData()
    satdat.filename = filename
    satdat.filesize = filesize

    #open file
    if(gz == None):
        fd = open(filename,"rb")
    else:
        fd = gzip.open(filename,"rb")
        

    #first read header
    br = fd.read(RECSIZE)## read record by record
    (year,month,day,utc,satid,sattyp,nchans,nghtimg) = struct.unpack("10s10s10s10s10s10s10s10s",br[0:80])
    satdat.year = int(year)
    satdat.month = int(month)
    satdat.utc = int(utc)
    satdat.satid = int(satid)
    satdat.sattyp = int(sattyp)
    satdat.nchans = int(nchans)
    satdat.nghtimg = int(nghtimg)
    del year, month, utc, satid, sattyp, nchans, nghtimg

    satdat.lngs = []
    satdat.lats = []
    satdat.x = []
    satdat.y = []
    satdat.dxs1s = []
    satdat.dxadd1s = []
    satdat.dxs2s = []
    satdat.dxs3s = []
    satdat.dxadd3s = []
    satdat.dxs4s = []

    #Next read each piece
    for i in range(1,numrecs):
        #read a new record
        br = bytearray(fd.read(RECSIZE))
        cur = 0#cursor in byte array
        #grab record header,includes longitudes, latitudes etc
        iwest,ieast,inorth,isouth,npix,iout = struct.unpack(">6I",br[0:24])
        lng,lat,x,y = (np.zeros(npix),np.zeros(npix),np.zeros(npix),np.zeros(npix))
        cur += 24
        for j in range(0,npix):
            (lng[j],lat[j],x[j],y[j]) = struct.unpack(">4H",br[cur+8*j:cur+8*(j+1)])

        satdat.lngs = np.append(satdat.lngs,lng)
        satdat.lats = np.append(satdat.lats,lat)
        satdat.x    = np.append(satdat.x,x)
        satdat.y    = np.append(satdat.y,y)

        #cursor start
        cur += 8*npix

        #Now read the data for each pixel
        for j in range(0,npix):
            #First read S1, 5 bytes per pixel
            dxs1 = DXS1(br[cur : cur + 5]) 
            satdat.dxs1s.append(dxs1)
            cur += 5
            #print dxs1.noday
            
            #next read Add1
            nbytes = satdat.nchans-2
            if(nbytes > 0):
                dxadd1 = DXADD1(br[cur:cur+nbytes])
                satdat.dxadd1s.append(dxadd1)
                cur   += nbytes

            #next read S2 (5 bytes), only if day
            if(dxs1.noday==0):
                dxs2 = DXS2(br[cur:cur+5])
                satdat.dxs2s.append(dxs2)
                cur += 5
            else:
                satdat.dxs2s.append(satData())

            #read S3 (7 bytes)
            dxs3 = DXS3(br[cur:cur+7])
            satdat.dxs3s.append(dxs3)
            cur += 7

            #read Add3 (3 bytes) only is sattyp is one of three values
            if(satdat.sattyp == -3 or satdat.sattyp == 1 or satdat.sattyp == 2):
                dxadd3 = DXADD3(br[cur:cur+3])
                satdat.dxadd3s.append(dxadd3)
                cur += 3
            else:
                satdat.dxadd3s.append(satData())

            #Read S4 (9 bytes) only if day
            if(dxs1.noday==0):
                dxs4 = DXS4(br[cur:cur+9])
                satdat.dxs4s.append(dxs4)
                cur += 9
            else:
                satdat.dxs4s.append(satData())
            
    fd.close() 

    return satdat
