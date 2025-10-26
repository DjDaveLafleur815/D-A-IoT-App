class Device {
  final String name;
  final String type;
  final String room;
  Device({required this.name, required this.type, required this.room});

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        name: json["device"] ?? json["name"] ?? "",
        type: json["type"] ?? "",
        room: json["room"] ?? "",
      );
}
