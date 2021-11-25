from __future__ import annotations

from dataclasses import dataclass


@dataclass
class DXS4:
    """The DXS4 data. 9 bytes.
    vret   :  4;
    vcsret :  4;
    vcsrad :  8;
    valbta :  8;
    vcsalb :  8;
    vtmp   :  8;
    vprs   :  8;
    vtauic :  8;
    vtmpic :  8;
    vprsic :  8;"""

    vret: int
    vcsret: int
    vcsrad: int
    valbta: int
    vcsalb: int
    vtmp: int
    vprs: int
    vtauic: int
    vtmpic: int
    vprsic: int

    @staticmethod
    def from_bytes(br: bytes) -> DXS4:
        vret = (br[0] & 0b11110000) >> 4
        vcsret = br[0] & 0b00001111
        vcsrad = br[1]
        valbta = br[2]
        vcsalb = br[3]
        vtmp = br[4]
        vprs = br[5]
        vtauic = br[6]
        vtmpic = br[7]
        vprsic = br[8]
        return DXS4(
            vret=vret,
            vcsret=vcsret,
            vcsrad=vcsrad,
            valbta=valbta,
            vcsalb=vcsalb,
            vtmp=vtmp,
            vprs=vprs,
            vtauic=vtauic,
            vtmpic=vtmpic,
            vprsic=vprsic,
        )
