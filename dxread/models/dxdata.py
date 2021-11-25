from __future__ import annotations

import os
from dataclasses import dataclass
from gzip import GzipFile
from typing import BinaryIO, List, Union

from dxread.constants import RECSIZE
from dxread.models.dxheader import DXHeader
from dxread.models.dxrecord import DXRecord
from dxread.models.dxpixel import DXPixel
from dxread.utils import get_uncompressed_size, open_file_context


@dataclass
class DXData:
    """Satellite data object.
    Represents a DX data file.

    See
    https://isccp.giss.nasa.gov/pub/documents/d-doc.pdf
    for more information.
    """

    filename: str
    filesize: int
    header: DXHeader
    records: List[DXRecord]

    @staticmethod
    def from_filename(filename: str, gzipped: bool = False):
        if gzipped:
            # Only works for files < 2GB!
            filesize = get_uncompressed_size(filename)
        else:
            filesize = os.path.getsize(filename)

        # open file
        with open_file_context(filename, gzipped=gzipped) as file_descriptor:
            return DXData.from_file(
                file_descriptor, filename=filename, filesize=filesize
            )

    @staticmethod
    def from_file(
        file_descriptor: Union[BinaryIO, GzipFile], filename: str, filesize: int
    ):
        numrecs = filesize // RECSIZE
        # first read header
        buffer = file_descriptor.read(RECSIZE)  # read record by record
        header = DXHeader.from_bytes(buffer[0:80])

        records = []
        # Next read each piece
        for _ in range(1, numrecs):
            # read a new record
            buffer = bytearray(file_descriptor.read(RECSIZE))
            record = DXRecord.from_bytes(buffer, header=header)
            records.append(record)

        return DXData(
            filename=filename,
            filesize=filesize,
            header=header,
            records=records,
        )

    def pixels(self) -> List[DXPixel]:
        pixels = []
        for record in self.records:
            pixels.extend(record.pixels)
        return pixels
