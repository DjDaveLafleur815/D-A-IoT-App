class AppUser {
  final String email;
  AppUser(this.email);

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      AppUser(json["email"] ?? "");
}
