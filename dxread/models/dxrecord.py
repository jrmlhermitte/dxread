from __future__ import annotations

from dataclasses import dataclass
from typing import List

from dxread.models.dxheader import DXHeader
from dxread.models.dxpixel import DXPixel
from dxread.models.dxrecord_header import DXRecordHeader


@dataclass
class DXRecord:
    header: DXRecordHeader
    pixels: List[DXPixel]

    @staticmethod
    def from_bytes(buffer: bytes, header: DXHeader) -> DXRecord:
        record_header = DXRecordHeader.from_bytes(buffer[0:24])
        pixels = DXPixel.from_bytes(
            buffer[24:], header=header, record_header=record_header
        )

        return DXRecord(
            header=record_header,
            pixels=pixels,
        )
