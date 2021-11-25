from __future__ import annotations
from dataclasses import dataclass

from typing import List


@dataclass
class DXADD1:
    """The DXadd1 data: number of channels number bytes."""

    arad: List[int]

    @staticmethod
    def from_bytes(br: bytes) -> DXADD1:
        arad = [int(bt) for bt in br]
        return DXADD1(arad=arad)
