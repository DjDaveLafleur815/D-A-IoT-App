class Room {
  final String name;
  Room({required this.name});

  factory Room.fromJson(Map<String, dynamic> json) =>
      Room(name: json["name"] ?? json["r.name"] ?? "");
}
