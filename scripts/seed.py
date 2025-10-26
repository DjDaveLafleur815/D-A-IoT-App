# python -m scripts.seed
from app.neo4j_client import get_driver, init_constraints

def seed():
    init_constraints()
    with get_driver().session() as s:
        s.run("""
        MERGE (r:Room {id:'living'}) SET r.name='Salon'
        MERGE (r2:Room {id:'kitchen'}) SET r2.name='Cuisine'
        MERGE (d:Device {id:'esp32-1'}) SET d.name='ESP32 Salon'
        MERGE (d2:Device {id:'esp32-2'}) SET d2.name='ESP32 Cuisine'
        MERGE (r)-[:CONTAINS]->(d)
        MERGE (r2)-[:CONTAINS]->(d2)
        MERGE (s:Sensor {id:'temp-1'}) SET s.type='temperature'
        MERGE (s2:Sensor {id:'hum-1'}) SET s2.type='humidity'
        MERGE (d)-[:HAS_SENSOR]->(s)
        MERGE (d2)-[:HAS_SENSOR]->(s2)
        """)

if __name__ == "__main__":
    seed()
    print("✅ seed done")
