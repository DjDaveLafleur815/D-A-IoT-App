# 📱 D-A IoT — Plateforme Domotique Intelligente

## 🎯 Objet du projet

D-A IoT est une solution complète de domotique permettant :
- la gestion de capteurs et appareils connectés (IoT),
- la supervision en temps réel,
- la visualisation graphique des données,
- le contrôle de l'environnement (température, lumière, sécurité),
- l’accès multi-plateforme (Flutter Web, Desktop, iOS, Android).

Le projet combine **micro-services**, **streaming MQTT**, **Neo4j GraphDB**, **WebSockets**, **FastAPI** et **Flutter**.

---

## 🔥 Fonctionnalités

✅ Authentification JWT / Auth0  
✅ Inscription & connexion  
✅ Appareils, pièces, capteurs  
✅ Graphiques en temps réel  
✅ Visualisation relationnelle (Neo4j)  
✅ Simulation IoT (virtuel, demo)  
✅ WebSockets → état instantané  
✅ MQTT → messages IoT standard  
✅ Docker → déploiement facile  

---

## 🏗️ Architecture

### Backend (FastAPI)
- expose des API REST
- gère les utilisateurs, appareils, pièces et capteurs
- communique avec Neo4j
- diffuse les changements via WebSockets

### Message Broker (MQTT)
- transport des messages IoT
- alimente les capteurs virtuels ou réels

### Base de données (Neo4j)
- base orientée graphes
- modèle :
  - `(User)-[:OWNS]->(Device)`
  - `(Room)-[:CONTAINS]->(Sensor)`
  - `(Sensor)-[:MEASURES]->(Value)`

### Frontend (Flutter)
- multi-plateforme
- responsive
- dashboard graphique
- connexion Auth0 / Email

---

## 🧪 Simulation IoT

Un simulateur Python envoie :
- température
- humidité
- luminosité
- mouvement

Commande :

```bash
cd simulator
pip install -r requirements.txt
python simulator.py
