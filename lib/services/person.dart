class Person {
  final String name;
  final String role;
  final String organization;
  final String imageUrl;

  Person({
    required this.name,
    required this.role,
    required this.organization,
    required this.imageUrl,
  });

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      organization: map['organization'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}