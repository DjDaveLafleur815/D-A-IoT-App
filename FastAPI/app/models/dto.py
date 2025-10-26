from pydantic import BaseModel

class UserDTO(BaseModel):
    email: str
    password: str | None = None

class RoomDTO(BaseModel):
    name: str

class DeviceDTO(BaseModel):
    name: str
    type: str
    room: str

class SensorDTO(BaseModel):
    name: str
    unit: str
    device: str
