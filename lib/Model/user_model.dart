class User {
  final String id;

  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '', // Provide default value for non-nullable fields

      email: json['email'] ?? '', // Provide default value
      role: json['role'] ?? '', // Provide default value
      firstName: json['first_name'] ?? '', // Provide default value
      lastName: json['last_name'] ?? '', // Provide default value
      phoneNumber: json['phone_number'] ?? '', // Provide default value
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
    };
  }
}
