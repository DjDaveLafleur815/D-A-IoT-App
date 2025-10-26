# D-A IoT

Plateforme domotique en temps réel basée sur FastAPI, Neo4j, MQTT et Flutter.

## Features
- Real-time dashboard (WebSockets)
- MQTT IoT sensors
- Graph visualization (Neo4j)
- JWT auth (dev)
- Docker-ready

## Requirements
- Docker / Docker Desktop
- Git
- Python 3.10+
- Flutter SDK

## Installation
git clone https://github.com/<user>/D-A-IoT.git

cd D-A-IoT-App

docker compose up --build

## Services
Swagger UI → http://localhost:8000/docs  
Neo4j Browser → http://localhost:7474/browser  

## Flutter UI
cd GUI

flutter pub get

flutter run

## IoT Simulator
cd simulator

pip install -r requirements.txt

python simulator.py

## Project structure
FastAPI      # backend
GUI          # Flutter app
Neo4j        # graph DB
scripts      # tools
simulator    # virtual sensors
docker-compose.yml

## License
MIT
