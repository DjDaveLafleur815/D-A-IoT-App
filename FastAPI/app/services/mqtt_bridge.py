import json
import threading
import time
import paho.mqtt.client as mqtt
from ..config import settings

class MqttBridge:
    def __init__(self):
        self.host = settings.mqtt_host
        self.port = settings.mqtt_port
        self.topic_base = settings.mqtt_topic_base.rstrip("/")
        self._client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="fastapi-bridge")
        self._client.on_connect = self._on_connect
        self._client.on_message = self._on_message
        self._started = False

    def _on_connect(self, client, userdata, flags, reason_code, properties):
        print("✅ MQTT connected", reason_code)
        # Subscribe to sensor topics: home/+/+/sensor/+/value
        topic = f"{self.topic_base}/+/+/sensor/+/value"
        client.subscribe(topic)

    def _on_message(self, client, userdata, msg):
        try:
            payload = msg.payload.decode("utf-8")
            data = json.loads(payload)
            # here you could persist into Neo4j, or broadcast via websocket
            # to keep it simple, we only print — persistence is done in REST endpoint
            print(f"[MQTT] {msg.topic} -> {data}")
        except Exception as e:
            print("MQTT message error:", e)

    def start(self):
        if self._started:
            return
        self._started = True
        th = threading.Thread(target=self._run, daemon=True)
        th.start()

    def _run(self):
        while True:
            try:
                self._client.connect(self.host, self.port, keepalive=30)
                self._client.loop_forever()
            except Exception as e:
                print("MQTT reconnect in 3s:", e)
                time.sleep(3)

mqtt_bridge = MqttBridge()
