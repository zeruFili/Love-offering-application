import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../apis/registration_api.dart'; // Import the RegistrationApis class

class RegistrationController extends GetxController {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  // New controller
  final TextEditingController phoneController =
      TextEditingController(); // Optional

  Future<bool> registerUser() async {
    String firstname = firstnameController.text;
    String lastname = lastnameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phonenumber =
        phoneController.text; // Get birthday from the controller

    print(
        'Accepted: Firstname: $firstname, Lastname: $lastname, Email: $email, Password: $password, phonenumber: $phonenumber');

    final registrationApi =
        RegistrationApis(); // Create an instance of RegistrationApis

    // Prepare the data to be sent
    var data = {
      'first_name': firstname,
      'last_name': lastname,
      'email': email,
      'password': password,
      'phone_number': phonenumber,
    };

    try {
      final response =
          await registrationApi.register(data); // Call the register method

      if (response.statusCode == 201) {
        // User registered successfully
        print('User registered: ${response.data}');
        return true; // Indicate success
      } else {
        // Handle error
        print('Failed to register user: ${response.data}');
        return false; // Indicate failure
      }
    } catch (e) {
      // Handle exceptions
      print('Error occurred: $e');
      return false; // Indicate failure
    }
  }

  @override
  void onClose() {
    // Dispose of controllers only when the controller is closed
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose(); // Added disposal of birthday controller
    // Optional
    super.onClose();
  }
}
