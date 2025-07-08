import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../utils/api_endpoints.dart';
import './youTubeVideoPage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Define the consistent color scheme
  static const Color primaryColor = Color(0xFF0A5D4A);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color secondaryTextColor = Colors.black54;
  static const Color iconColor = Colors.white;
  static const Color textFieldColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 20.0 : screenSize.width * 0.3,
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
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.auto_graph,
                        color: iconColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Love Offering',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: isSmallScreen ? 24 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 40),
                _buildLoginCard(isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(bool isSmallScreen) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sign In to Love Offering',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          const SizedBox(height: 8),
          Text(
            'Your generosity makes a difference!',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: secondaryTextColor,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
          SizedBox(height: isSmallScreen ? 30 : 40),
          _buildTextField(
            emailController,
            'Email or phone number',
            false,
            isSmallScreen,
            Icons.email_outlined,
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0),
          SizedBox(height: isSmallScreen ? 16 : 20),
          _buildTextField(
            passwordController,
            'Password',
            true,
            isSmallScreen,
            Icons.lock_outline,
          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0),
          SizedBox(height: isSmallScreen ? 30 : 40),
          _buildLoginButton(isSmallScreen)
              .animate()
              .fadeIn(delay: 1000.ms, duration: 600.ms)
              .scale(begin: const Offset(0.95, 0.95)),
          SizedBox(height: isSmallScreen ? 20 : 24),
          _buildForgotPasswordButton(isSmallScreen)
              .animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms),
          SizedBox(height: isSmallScreen ? 30 : 40),
          const Divider(thickness: 1),
          SizedBox(height: isSmallScreen ? 30 : 40),
          _buildSignUpButton(isSmallScreen)
              .animate()
              .fadeIn(delay: 1400.ms, duration: 600.ms)
              .scale(begin: const Offset(0.95, 0.95)),
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
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: textColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: textFieldColor,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(
          prefixIcon,
          color: primaryColor.withOpacity(0.7),
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
            color: primaryColor,
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

  Widget _buildLoginButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  bool success = await loginUser(
                    emailController.text,
                    passwordController.text,
                  );

                  if (success) {
                    Get.offAll(() => YouTubeVideoPage());
                  } else {
                    Get.snackbar(
                      'Login Failed',
                      'Please check your credentials.',
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
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withOpacity(0.6),
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
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(bool isSmallScreen) {
    return TextButton(
      onPressed: () {
        // Implement forgot password functionality
      },
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
      child: Text(
        'Forgot your password?',
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
        ),
      ),
    );
  }

  Widget _buildSignUpButton(bool isSmallScreen) {
    return OutlinedButton(
      onPressed: () {
        Get.toNamed(ApiEndPoints.registerEmail);
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
        padding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 16 : 20,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Create New Account',
        style: TextStyle(
          fontSize: isSmallScreen ? 16 : 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
