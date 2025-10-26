from pydantic import BaseModel, Field, EmailStr
from typing import Optional, List

# --- Users ---
class UserCreate(BaseModel):
    email: EmailStr
    password: str  # dev mode only
    display_name: str | None = None

class UserOut(BaseModel):
    email: EmailStr
    display_name: str | None = None

# --- Rooms ---
class RoomCreate(BaseModel):
    id: str = Field(..., examples=["living"])
    name: str

class RoomOut(BaseModel):
    id: str
    name: str

# --- Devices ---
class DeviceCreate(BaseModel):
    id: str
    name: str
    room_id: str

class DeviceOut(BaseModel):
    id: str
    name: str
    room_id: str

# --- Sensors ---
class SensorCreate(BaseModel):
    id: str
    type: str
    device_id: str

class SensorOut(BaseModel):
    id: str
    type: str
    device_id: str

class SensorValue(BaseModel):
    sensor_id: str
    value: float
    ts: int
