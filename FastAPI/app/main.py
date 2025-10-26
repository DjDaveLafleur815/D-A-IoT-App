from fastapi import FastAPI, WebSocket
from app.routers import users, devices, rooms, sensors
from app.services.mqtt_bridge import start_mqtt
from app.services.websocket_manager import register, unregister
from threading import Thread

app = FastAPI(title="D-A IoT API")

# Routers
app.include_router(users.router)
app.include_router(devices.router)
app.include_router(rooms.router)
app.include_router(sensors.router)

# WebSocket
@app.websocket("/ws")
async def ws_route(ws: WebSocket):
    await register(ws)
    try:
        while True:
            await ws.receive_text()
    except:
        await unregister(ws)

# MQTT thread
Thread(target=start_mqtt, daemon=True).start()
