class Room {
  final String id;
  final String name;

  Room({required this.id, required this.name});

  factory Room.fromJson(Map<String, dynamic> j) =>
      Room(id: j['id'], name: j['name']);
}
