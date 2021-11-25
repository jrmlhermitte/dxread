from __future__ import annotations
from dataclasses import dataclass


@dataclass
class DXS1:
    """The S1 data set for weather. 5 bytes long"""

    noday: int
    bxshor: int
    lndwtr: int
    hitopo: int
    snoice: int
    timspa: int
    isclog: int
    bxithr: int
    mue: int
    irad: int
    bxicsr: int

    @staticmethod
    def from_bytes(br: bytes) -> DXS1:
        """Takes a 5 byte record and converts it
        to the S1 data.

        NOTE: for each bit, you count
            from highest to lowest order. So noday is actually
            the first element from the left (so 2^8).
            I could have used shift operators but I feel the
            brute force notation is more readable for this purpose (and
                faster). (a & 0b1000000) >>7 is equivalent to:
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
        """
        noday = (br[0] & 0b10000000) >> 7
        bxshor = (br[0] & 0b01000000) >> 6
        lndwtr = (br[0] & 0b00100000) >> 5
        hitopo = (br[0] & 0b00010000) >> 4
        snoice = (br[0] & 0b00001100) >> 2
        timspa = br[0] & 0b00000011
        isclog = (br[1] & 0b11111000) >> 3
        bxithr = br[1] & 0b00000111
        mue = int(br[2])
        irad = int(br[3])
        bxicsr = int(br[4])

        return DXS1(
            noday=noday,
            bxshor=bxshor,
            lndwtr=lndwtr,
            hitopo=hitopo,
            snoice=snoice,
            timspa=timspa,
            isclog=isclog,
            bxithr=bxithr,
            mue=mue,
            irad=irad,
            bxicsr=bxicsr,
        )
