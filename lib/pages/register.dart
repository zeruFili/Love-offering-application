import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/registeration_controller.dart';
import '../utils/api_endpoints.dart';
import '../utils/password_validation.dart'; // Import the validation file

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegistrationController registrationController =
      Get.put(RegistrationController());
  bool isLoading = false;
  String emailError = '';
  String firstnameError = '';
  String lastnameError = '';
  String phoneNumberError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF0A5D4A),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 20.0 : screenSize.width * 0.3,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A5D4A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Love Offering',
                      style: TextStyle(
                        color: const Color(0xFF0A5D4A),
                        fontSize: isSmallScreen ? 24 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 40),
                _buildRegisterCard(isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterCard(bool isSmallScreen) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create a new account',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          const SizedBox(height: 8),
          Text(
            "It's quick and easy.",
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.black54,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  registrationController.firstnameController,
                  'First name',
                  false,
                  isSmallScreen,
                  Icons.person_outline,
                  firstnameError,
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms)
                    .slideX(begin: 0.2, end: 0),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  registrationController.lastnameController,
                  'Last name',
                  false,
                  isSmallScreen,
                  Icons.person_outline,
                  lastnameError,
                )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideX(begin: 0.2, end: 0),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(
            registrationController.emailController,
            'Email',
            false,
            isSmallScreen,
            Icons.email_outlined,
            emailError,
          )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0),
          const SizedBox(height: 20),
          _buildTextField(
            registrationController.passwordController,
            'New Password',
            true,
            isSmallScreen,
            Icons.lock_outline,
            passwordError,
          )
              .animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0),
          const SizedBox(height: 20),
          _buildTextField(
            registrationController.confirmPasswordController,
            'Confirm Password',
            true,
            isSmallScreen,
            Icons.lock_outline,
            confirmPasswordError,
          )
              .animate()
              .fadeIn(delay: 1400.ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0),
          const SizedBox(height: 20),
          _buildTextField(
            registrationController.phoneController,
            'Phone Number',
            false,
            isSmallScreen,
            Icons.phone_outlined,
            phoneNumberError,
          )
              .animate()
              .fadeIn(delay: 1600.ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0),
          const SizedBox(height: 30),
          _buildSignUpButton(isSmallScreen)
              .animate()
              .fadeIn(delay: 1800.ms, duration: 600.ms)
              .scale(begin: const Offset(0.95, 0.95)),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () => Get.toNamed(ApiEndPoints.loginEmail),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0A5D4A),
              ),
              child: Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 2000.ms, duration: 600.ms),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    bool obscureText,
    bool isSmallScreen,
    IconData prefixIcon,
    String errorText,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black45,
        ),
        errorText: errorText.isNotEmpty ? errorText : null,
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFF0A5D4A).withOpacity(0.7),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF0A5D4A),
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isSmallScreen ? 16 : 20,
        ),
      ),
    );
  }

  Widget _buildSignUpButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                  passwordError = PasswordValidation.validate(
                          registrationController.passwordController.text) ??
                      '';
                  confirmPasswordError = registrationController
                              .passwordController.text !=
                          registrationController.confirmPasswordController.text
                      ? 'Passwords do not match'
                      : '';
                });

                if (passwordError.isEmpty && confirmPasswordError.isEmpty) {
                  try {
                    bool success = await registrationController.registerUser();
                    if (success) {
                      // Show success snackbar
                      Get.snackbar(
                        'Registration Successful!',
                        'Check your email, verification has been sent',
                        backgroundColor: Colors.green[100],
                        colorText: Colors.green[800],
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: Colors.green[800],
                        ),
                        duration: const Duration(seconds: 4),
                      );

                      // Navigate to verify email screen
                      Get.toNamed(ApiEndPoints.verifyEmail);
                    } else {
                      Get.snackbar(
                        'Registration Failed',
                        'Please check your information and try again.',
                        backgroundColor: Colors.red[100],
                        colorText: Colors.red[800],
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    }
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                } else {
                  setState(() {
                    isLoading =
                        false; // Reset loading state if validation fails
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A5D4A),
          disabledBackgroundColor: const Color(0xFF0A5D4A).withOpacity(0.6),
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 16 : 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
