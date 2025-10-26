from fastapi import APIRouter, Depends, HTTPException
from ..models.dto import DeviceCreate, DeviceOut
from ..neo4j_client import get_driver
from ..auth.deps import get_current_user

router = APIRouter(prefix="/devices", tags=["devices"])

@router.post("", response_model=DeviceOut)
def create_device(dev: DeviceCreate, _=Depends(get_current_user)):
    with get_driver().session() as s:
        res = s.run("""
            MATCH (r:Room {id:$room_id})
            MERGE (d:Device {id:$id})
            ON CREATE SET d.name=$name
            ON MATCH SET d.name=$name
            MERGE (r)-[:CONTAINS]->(d)
            RETURN d.id AS id, d.name AS name, r.id AS room_id
        """, id=dev.id, name=dev.name, room_id=dev.room_id).single()
        if not res:
            raise HTTPException(404, "Room not found")
        return DeviceOut(id=res["id"], name=res["name"], room_id=res["room_id"])

@router.get("", response_model=list[DeviceOut])
def list_devices(_=Depends(get_current_user)):
    with get_driver().session() as s:
        res = s.run("""
            MATCH (r:Room)-[:CONTAINS]->(d:Device)
            RETURN d.id AS id, d.name AS name, r.id AS room_id
            ORDER BY id
        """)
        return [DeviceOut(id=r["id"], name=r["name"], room_id=r["room_id"]) for r in res]
