"""
Simple simulator: publishes random values to MQTT every 2s.
Run from host:
    python -m venv .venv && source .venv/bin/activate
    pip install -r requirements.txt
    python simulator.py --host localhost --topic home/living/esp32-1/sensor/temp-1/value
"""
import time, json, random, argparse
import paho.mqtt.client as mqtt

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="localhost")
    ap.add_argument("--port", type=int, default=1883)
    ap.add_argument("--topic", default="home/living/esp32-1/sensor/temp-1/value")
    args = ap.parse_args()

    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="simulator")
    client.connect(args.host, args.port, keepalive=30)
    client.loop_start()

    try:
        while True:
            payload = {
                "value": round(random.uniform(18, 25), 2),
                "ts": int(time.time()*1000)
            }
            client.publish(args.topic, json.dumps(payload), qos=0)
            print("→", args.topic, payload)
            time.sleep(2)
    finally:
        client.loop_stop()
        client.disconnect()

if __name__ == "__main__":
    main()
