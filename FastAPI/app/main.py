from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from .config import settings
from .neo4j_client import init_constraints, close_driver
from .services.mqtt_bridge import mqtt_bridge
from .services.websocket_manager import ws_manager
from .routers import users, rooms, devices, sensors

app = FastAPI(title="D-A-IoT API", version="1.0.0")

# CORS
origins = ["*"] if settings.cors_origins == "*" else [o.strip() for o in settings.cors_origins.split(",")]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(users.router)
app.include_router(rooms.router)
app.include_router(devices.router)
app.include_router(sensors.router)

@app.on_event("startup")
def on_start():
    init_constraints()
    mqtt_bridge.start()
    print("✅ Startup done")

@app.on_event("shutdown")
def on_stop():
    close_driver()

@app.get("/")
def root():
    return {"ok": True, "service": "D-A-IoT API"}

# WS
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await ws_manager.connect(websocket)
    try:
        while True:
            msg = await websocket.receive_text()
            await ws_manager.broadcast(f"echo: {msg}")
    except WebSocketDisconnect:
        ws_manager.disconnect(websocket)
