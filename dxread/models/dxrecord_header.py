from __future__ import annotations

import struct
from dataclasses import dataclass


@dataclass
class DXRecordHeader:
    iwest: int
    ieast: int
    inorth: int
    isouth: int
    npix: int
    iout: int

    @staticmethod
    def from_bytes(buffer: bytes) -> DXRecordHeader:
        # grab record header,includes longitudes, latitudes etc
        # See Table 2.3.4 from
        # https://isccp.giss.nasa.gov/pub/documents/d-doc.pdf
        iwest, ieast, inorth, isouth, npix, iout = struct.unpack(">6I", buffer)
        return DXRecordHeader(
            iwest=iwest,
            ieast=ieast,
            inorth=inorth,
            isouth=isouth,
            npix=npix,
            iout=iout,
        )
