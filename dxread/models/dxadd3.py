from __future__ import annotations

from dataclasses import dataclass


@dataclass
class DXADD3:
    """The DXADD3 data. 3 bytes.
    nref   :  8;
    nthr   :  8;
    ncsref :  8;
    """

    nref: int
    nthr: int
    ncsref: int

    @staticmethod
    def from_bytes(br: bytes) -> DXADD3:
        nref = br[0]
        nthr = br[1]
        ncsref = br[2]
        return DXADD3(
            nref=nref,
            nthr=nthr,
            ncsref=ncsref,
        )
