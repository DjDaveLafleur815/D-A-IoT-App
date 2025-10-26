# python -m scripts.create_device --room living --device esp32-3 --name "ESP Salon 2"
import argparse
from app.neo4j_client import get_driver

def create(room_id: str, device_id: str, name: str):
    with get_driver().session() as s:
        res = s.run("""
        MATCH (r:Room {id:$room})
        MERGE (d:Device {id:$id})
        SET d.name=$name
        MERGE (r)-[:CONTAINS]->(d)
        RETURN d.id as id, d.name as name, r.id as room_id
        """, room=room_id, id=device_id, name=name).single()
        return res

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--room", required=True)
    p.add_argument("--device", required=True)
    p.add_argument("--name", default="ESP Device")
    args = p.parse_args()
    rec = create(args.room, args.device, args.name)
    print("✅", dict(rec) if rec else "room not found")
