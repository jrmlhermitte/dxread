from __future__ import annotations

import struct
from dataclasses import dataclass
from typing import List


@dataclass
class DXPoint:
    lat: float
    lon: float
    x: int
    y: int

    @staticmethod
    def from_bytes(buffer: bytes) -> DXPoint:
        (lon_10, lat_10, x, y) = struct.unpack(">4H", buffer)
        lat = lat_10 / 10.0 - 90
        lon = lon_10 / 10.0
        return DXPoint(lat=lat, lon=lon, x=x, y=y)

    @staticmethod
    def list_from_bytes(buffer: bytes) -> List[DXPoint]:
        npoints = len(buffer) // 8
        points = []
        for j in range(0, npoints):
            point = DXPoint.from_bytes(buffer[j * 8 : (j + 1) * 8])
            points.append(point)
        return points
