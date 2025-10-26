from fastapi import APIRouter, Depends
from app.models.dto import DeviceDTO
from app.neo4j_client import get_db

router = APIRouter(prefix="/devices")

@router.post("/")
def create_device(body: DeviceDTO, db=Depends(get_db)):
    db.run("""
        MATCH (r:Room {name:$room})
        CREATE (d:Device {name:$name, type:$type})-[:INSTALLED_IN]->(r)
    """, name=body.name, type=body.type, room=body.room)
    return {"ok": True}

@router.get("/")
def list_devices(db=Depends(get_db)):
    res = db.run("""
        MATCH (d:Device)-[:INSTALLED_IN]->(r:Room)
        RETURN d.name AS device, d.type AS type, r.name AS room
    """)
    return list(res)
