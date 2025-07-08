class RegistrationUser {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  RegistrationUser({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  // Factory method to create a RegistrationUser from JSON
  factory RegistrationUser.fromJson(Map<String, dynamic> json) {
    return RegistrationUser(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  // Method to convert RegistrationUser to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
    };
  }
}
