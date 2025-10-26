class UserModel {
  final String email;
  final String? displayName;

  UserModel({required this.email, this.displayName});

  factory UserModel.fromJson(Map<String, dynamic> j) =>
      UserModel(email: j['email'], displayName: j['display_name'] ?? j['name']);
}
