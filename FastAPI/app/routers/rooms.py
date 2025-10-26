from fastapi import APIRouter, Depends
from app.models.dto import RoomDTO
from app.neo4j_client import get_db

router = APIRouter(prefix="/rooms")

@router.post("/")
def create_room(body: RoomDTO, db=Depends(get_db)):
    db.run("CREATE (r:Room {name:$name})", name=body.name)
    return {"ok": True}

@router.get("/")
def list_rooms(db=Depends(get_db)):
    res = db.run("MATCH (r:Room) RETURN r.name AS name")
    return [record["name"] for record in res]
