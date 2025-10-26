import paho.mqtt.client as mqtt
import json
from app.services.websocket_manager import broadcast

def on_message(client, userdata, msg):
    payload = msg.payload.decode()
    try:
        data = json.loads(payload)
    except:
        return

    # relay automatiquement sur WebSocket
    import asyncio
    asyncio.run(broadcast({"topic": msg.topic, "data": data}))

def start_mqtt():
    client = mqtt.Client()
    client.on_message = on_message
    client.connect("mqtt", 1883)
    client.subscribe("#")
    client.loop_start()
