# python -m scripts.health_check
import socket
from app.config import settings
from app.neo4j_client import get_driver

def check():
    print("Neo4j driver:", get_driver())
    s = socket.socket()
    s.settimeout(2)
    s.connect((settings.mqtt_host, settings.mqtt_port))
    print("MQTT reachable")
    s.close()

if __name__ == "__main__":
    check()
    print("✅ health ok")
