class Sensor {
  final String name;
  final String unit;
  final String device;
  Sensor({required this.name, required this.unit, required this.device});

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
        name: json["sensor"] ?? json["name"] ?? "",
        unit: json["unit"] ?? "",
        device: json["device"] ?? "",
      );
}
