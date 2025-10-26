from fastapi import APIRouter, Depends
from app.models.dto import SensorDTO
from app.neo4j_client import get_db

router = APIRouter(prefix="/sensors")

@router.post("/")
def create_sensor(body: SensorDTO, db=Depends(get_db)):
    db.run("""
        MATCH (d:Device {name:$device})
        CREATE (s:Sensor {name:$name,unit:$unit})-[:ON]->(d)
    """, name=body.name, unit=body.unit, device=body.device)
    return {"ok": True}

@router.get("/")
def list_sensors(db=Depends(get_db)):
    res = db.run("""
        MATCH (s:Sensor)-[:ON]->(d:Device)
        RETURN s.name AS sensor, s.unit AS unit, d.name AS device
    """)
    return list(res)
