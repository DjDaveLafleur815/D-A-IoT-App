class Device {
  final String id;
  final String name;
  final String roomId;

  Device({required this.id, required this.name, required this.roomId});

  factory Device.fromJson(Map<String, dynamic> j) =>
      Device(id: j['id'], name: j['name'], roomId: j['room_id']);
}
