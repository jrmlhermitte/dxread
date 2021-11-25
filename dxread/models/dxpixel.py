from __future__ import annotations

from dataclasses import dataclass
from typing import List

from dxread.models.dxheader import DXHeader
from dxread.models.dxpoint import DXPoint
from dxread.models.dxpointdata import DXPointData
from dxread.models.dxrecord_header import DXRecordHeader


@dataclass
class DXPixel:
    point: DXPoint
    data: DXPointData

    @classmethod
    def from_bytes(
        cls, buffer: bytes, header: DXHeader, record_header: DXRecordHeader
    ) -> List[DXPixel]:
        points = DXPoint.list_from_bytes(buffer[: 8 * record_header.npix])
        buffer = buffer[8 * record_header.npix :]

        point_data_list = DXPointData.list_from_bytes(
            buffer, header=header, record_header=record_header
        )
        assert len(points) == len(point_data_list)

        return cls.from_lists(points=points, point_data_list=point_data_list)

    @staticmethod
    def from_lists(
        points: List[DXPoint], point_data_list: List[DXPointData]
    ) -> List[DXPixel]:
        pixels = []
        for point, point_data in zip(points, point_data_list):
            pixels.append(DXPixel(point=point, data=point_data))
        return pixels
