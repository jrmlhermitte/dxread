from __future__ import annotations

from dataclasses import dataclass


@dataclass
class DXS3:
    """The DXS3 data. 7 bytes
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
    """

    daynit: int
    ithr: int
    vthr: int
    shore: int
    iret: int
    icsret: int
    itmp: int
    iprs: int
    icstmp: int
    icsprs: int

    @staticmethod
    def from_bytes(br: bytes) -> DXS3:
        daynit = (br[0] & 0b10000000) >> 7
        ithr = (br[0] & 0b01110000) >> 4
        vthr = (br[0] & 0b00001110) >> 1
        shore = br[0] & 0b00000001
        iret = (br[1] & 0b11110000) >> 4
        icsret = br[1] & 0b00001111
        itmp = br[2]
        iprs = br[3]
        icstmp = br[4]
        icsprs = br[5]
        return DXS3(
            daynit=daynit,
            ithr=ithr,
            vthr=vthr,
            shore=shore,
            iret=iret,
            icsret=icsret,
            itmp=itmp,
            iprs=iprs,
            icstmp=icstmp,
            icsprs=icsprs,
        )
