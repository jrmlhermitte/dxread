from __future__ import annotations

from dataclasses import dataclass
from typing import List, Optional

from dxread.models.dxadd1 import DXADD1
from dxread.models.dxadd3 import DXADD3
from dxread.models.dxheader import DXHeader
from dxread.models.dxrecord_header import DXRecordHeader
from dxread.models.dxs1 import DXS1
from dxread.models.dxs2 import DXS2
from dxread.models.dxs3 import DXS3
from dxread.models.dxs4 import DXS4


@dataclass
class DXPointData:
    dxs1: DXS1
    dxadd1: Optional[DXADD1]
    dxs2: Optional[DXS2]
    dxs3: DXS3
    dxadd3: Optional[DXADD3]
    dxs4: Optional[DXS4]

    @staticmethod
    def list_from_bytes(
        buffer: bytes, record_header: DXRecordHeader, header: DXHeader
    ) -> List[DXPointData]:
        point_data_list = []
        # Now read the data for each pixel
        cur = 0
        for _ in range(0, record_header.npix):
            # First read S1, 5 bytes per pixel
            dxs1 = DXS1.from_bytes(buffer[cur : cur + 5])
            cur += 5
            # print dxs1.noday

            # next read Add1
            # if doesn't exist, just add zeros
            nbytes = header.nchans - 2
            dxadd1: Optional[DXADD1] = None
            if nbytes > 0:
                dxadd1_bytes = buffer[cur : cur + nbytes]
                dxadd1 = DXADD1.from_bytes(dxadd1_bytes)
                cur += nbytes

            # next read S2 (5 bytes), only if day
            dxs2: Optional[DXS2] = None
            if dxs1.noday == 0:
                dxs2_bytes = buffer[cur : cur + 5]
                dxs2 = DXS2.from_bytes(dxs2_bytes)
                cur += 5

            # read S3 (7 bytes)
            dxs3 = DXS3.from_bytes(buffer[cur : cur + 7])
            cur += 7

            # read Add3 (3 bytes) only is sattyp is one of three values
            dxadd3: Optional[DXADD3] = None
            if header.sattyp in (-3, 1, 2):
                dxs3_bytes = buffer[cur : cur + 3]
                dxadd3 = DXADD3.from_bytes(dxs3_bytes)
                cur += 3

            # Read S4 (9 bytes) only if day
            dxs4: Optional[DXS4] = None
            if dxs1.noday == 0:
                dxs4_bytes = buffer[cur : cur + 9]
                dxs4 = DXS4.from_bytes(dxs4_bytes)
                cur += 9

            point_data = DXPointData(
                dxs1=dxs1,
                dxadd1=dxadd1,
                dxs2=dxs2,
                dxs3=dxs3,
                dxadd3=dxadd3,
                dxs4=dxs4,
            )
            point_data_list.append(point_data)
        return point_data_list
