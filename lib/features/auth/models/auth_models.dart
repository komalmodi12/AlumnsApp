class LoginRequest {
  final String email;
  final String password;
  LoginRequest(this.email, this.password);
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class User {
  final int id;
  final String name;
  final String email;
  User({required this.id, required this.name, required this.email});
  factory User.fromJson(Map<String, dynamic> j) => User(
    id: j['id'] is int ? j['id'] : int.parse(j['id'].toString()),
    name: j['name'] ?? '',
    email: j['email'] ?? '',
  );
}

class LoginResponse {
  final String token;
  final User user;
  LoginResponse({required this.token, required this.user});
  factory LoginResponse.fromJson(Map<String, dynamic> j) => LoginResponse(
    token: j['token'] ?? '',
    user: User.fromJson(j['user'] ?? {}),
  );
}
