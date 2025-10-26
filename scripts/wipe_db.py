# python -m scripts.wipe_db
from app.neo4j_client import get_driver

def wipe():
    with get_driver().session() as s:
        s.run("MATCH (n) DETACH DELETE n")

if __name__ == "__main__":
    wipe()
    print("🔥 wiped")
