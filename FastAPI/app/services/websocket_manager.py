from fastapi import WebSocket

clients: list[WebSocket] = []

async def register(ws: WebSocket):
    await ws.accept()
    clients.append(ws)

async def unregister(ws: WebSocket):
    clients.remove(ws)

async def broadcast(message: dict):
    for ws in clients:
        await ws.send_json(message)
