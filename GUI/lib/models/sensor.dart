class Sensor {
  final String id;
  final String type;
  final String deviceId;

  Sensor({required this.id, required this.type, required this.deviceId});

  factory Sensor.fromJson(Map<String, dynamic> j) =>
      Sensor(id: j['id'], type: j['type'], deviceId: j['device_id']);
}
