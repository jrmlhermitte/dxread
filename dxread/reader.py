from dxread.models.dxdata import DXData


def read_dxdata(filename: str) -> DXData:
    return DXData.from_filename(filename)
