# D-A-IoT-App

Stack:
- **FastAPI** (backend API + WebSocket)
- **Neo4j** (graph DB)
- **Mosquitto** MQTT broker
- **Flutter** (mobile UI)

## Lancer

```bash
cp .env.example .env
# Édite les mots de passe/URIs si besoin
docker compose up --build
