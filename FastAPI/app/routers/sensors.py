from fastapi import APIRouter, Depends, HTTPException
from ..models.dto import SensorCreate, SensorOut, SensorValue
from ..neo4j_client import get_driver
from ..auth.deps import get_current_user

router = APIRouter(prefix="/sensors", tags=["sensors"])

@router.post("", response_model=SensorOut)
def create_sensor(s: SensorCreate, _=Depends(get_current_user)):
    with get_driver().session() as sess:
        res = sess.run("""
            MATCH (d:Device {id:$device_id})
            MERGE (sn:Sensor {id:$id})
            ON CREATE SET sn.type=$type
            ON MATCH SET sn.type=$type
            MERGE (d)-[:HAS_SENSOR]->(sn)
            RETURN sn.id AS id, sn.type AS type, d.id AS device_id
        """, id=s.id, type=s.type, device_id=s.device_id).single()
        if not res:
            raise HTTPException(404, "Device not found")
        return SensorOut(id=res["id"], type=res["type"], device_id=res["device_id"])

@router.get("", response_model=list[SensorOut])
def list_sensors(_=Depends(get_current_user)):
    with get_driver().session() as s:
        res = s.run("""
            MATCH (d:Device)-[:HAS_SENSOR]->(sn:Sensor)
            RETURN sn.id AS id, sn.type AS type, d.id AS device_id ORDER BY id
        """)
        return [SensorOut(id=r["id"], type=r["type"], device_id=r["device_id"]) for r in res]

@router.post("/value")
def push_value(v: SensorValue, _=Depends(get_current_user)):
    with get_driver().session() as s:
        res = s.run("""
            MATCH (sn:Sensor {id:$sid})
            MERGE (m:Measure {sensor_id:$sid, ts:$ts})
            SET m.value=$val
            MERGE (sn)-[:MEASURED]->(m)
            RETURN m
        """, sid=v.sensor_id, ts=v.ts, val=v.value).single()
        if not res:
            raise HTTPException(404, "Sensor not found")
        return {"status": "ok"}
