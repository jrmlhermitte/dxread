from __future__ import annotations

from dataclasses import dataclass


@dataclass
class DXS2:
    """The DXS2 data. 5 bytes.
    glint  :  1;
    vcslog :  4;
    bxvthr :  3;
    mu0    :  8;
    phi    :  8;
    vrad   :  8;
    bxvcsr :  8;
    """

    glint: int
    vcslog: int
    bxvthr: int
    mu0: int
    phi: int
    vrad: int
    bxvcsr: int

    @staticmethod
    def from_bytes(br: bytes) -> DXS2:
        glint = (br[0] & 0b10000000) >> 7
        vcslog = (br[0] & 0b01111000) >> 3
        bxvthr = br[0] & 0b00000111
        mu0 = br[1]
        phi = br[2]
        vrad = br[3]
        bxvcsr = br[4]
        return DXS2(
            glint=glint,
            vcslog=vcslog,
            bxvthr=bxvthr,
            mu0=mu0,
            phi=phi,
            vrad=vrad,
            bxvcsr=bxvcsr,
        )
