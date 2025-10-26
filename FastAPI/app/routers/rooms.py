from fastapi import APIRouter, Depends, HTTPException
from ..models.dto import RoomCreate, RoomOut
from ..neo4j_client import get_driver
from ..auth.deps import get_current_user

router = APIRouter(prefix="/rooms", tags=["rooms"])

@router.post("", response_model=RoomOut)
def create_room(room: RoomCreate, _=Depends(get_current_user)):
    with get_driver().session() as s:
        res = s.run("""
            MERGE (r:Room {id:$id})
            ON CREATE SET r.name=$name
            ON MATCH SET r.name=$name
            RETURN r.id AS id, r.name AS name
        """, id=room.id, name=room.name).single()
        return RoomOut(id=res["id"], name=res["name"])

@router.get("", response_model=list[RoomOut])
def list_rooms(_=Depends(get_current_user)):
    with get_driver().session() as s:
        res = s.run("MATCH (r:Room) RETURN r.id AS id, r.name AS name ORDER BY r.id")
        return [RoomOut(id=r["id"], name=r["name"]) for r in res]
