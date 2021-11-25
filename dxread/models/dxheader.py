from __future__ import annotations

import struct
from dataclasses import dataclass


@dataclass
class DXHeader:
    year: int
    month: int
    day: int
    utc: int
    satid: int
    sattyp: int
    nchans: int
    nghtimg: int

    @staticmethod
    def from_bytes(buffer: bytes) -> DXHeader:
        (year, month, day, utc, satid, sattyp, nchans, nghtimg) = struct.unpack(
            "10s10s10s10s10s10s10s10s", buffer
        )
        year = int(year)
        month = int(month)
        day = int(day)
        utc = int(utc)
        satid = int(satid)
        sattyp = int(sattyp)
        nchans = int(nchans)
        nghtimg = int(nghtimg)
        return DXHeader(
            year=year,
            month=month,
            day=day,
            utc=utc,
            satid=satid,
            sattyp=sattyp,
            nchans=nchans,
            nghtimg=nghtimg,
        )
