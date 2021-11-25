"""Commonly used utilities for reading DX satellite data."""
import gzip
import struct
from contextlib import contextmanager
from gzip import GzipFile
from typing import BinaryIO, Generator, Union


@contextmanager
def open_file_context(
    filename: str, gzipped: bool = False
) -> Generator[Union[GzipFile, BinaryIO], None, None]:
    """Context for opening a file with an additional option for gzipped files."""
    file_descriptor: Union[GzipFile, BinaryIO]
    if gzipped:
        with gzip.open(filename, "rb") as file_descriptor:
            yield file_descriptor
    else:
        with open(filename, "rb") as file_descriptor:
            yield file_descriptor


def get_uncompressed_size(filename: str) -> int:
    """Get uncompressed file size.

    From
        http://stackoverflow.com/questions/1704458/get-uncompressed-size-of-a-gz-file-in-python
    """
    with open(filename, "rb") as fin:
        fin.seek(-4, 2)
        return struct.unpack("I", fin.read(4))[0]
