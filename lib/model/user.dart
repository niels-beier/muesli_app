class User {
  int id;
  String name;
  String lastName;
  String email;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }

  @override String toString() {
    return 'User{id: $id, name: $name, lastName: $lastName, email: $email}';
  }
}
