import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/email.controller.dart';
import './youTubeVideoPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  // Define the consistent color scheme (matching login page)
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
                        Icons.email_outlined,
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
                _buildVerificationCard(isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationCard(bool isSmallScreen) {
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
          Icon(
            Icons.mark_email_read_outlined,
            size: isSmallScreen ? 60 : 80,
            color: primaryColor,
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms).scale(),
          SizedBox(height: isSmallScreen ? 20 : 30),
          Text(
            'Verify Your Email',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
          const SizedBox(height: 8),
          Text(
            'We\'ve sent a verification code to your email address. Please enter it below to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: secondaryTextColor,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
          SizedBox(height: isSmallScreen ? 30 : 40),
          _buildCodeTextField(isSmallScreen)
              .animate()
              .fadeIn(delay: 800.ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0),
          SizedBox(height: isSmallScreen ? 30 : 40),
          _buildVerifyButton(isSmallScreen)
              .animate()
              .fadeIn(delay: 1000.ms, duration: 600.ms)
              .scale(begin: const Offset(0.95, 0.95)),
          SizedBox(height: isSmallScreen ? 20 : 24),
          _buildResendCodeButton(isSmallScreen)
              .animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms),
          SizedBox(height: isSmallScreen ? 20 : 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Didn\'t receive the code? Check your spam folder or request a new one.',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 1400.ms, duration: 600.ms),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildCodeTextField(bool isSmallScreen) {
    return TextFormField(
      controller: codeController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor,
        fontSize: isSmallScreen ? 18 : 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 8,
      ),
      decoration: InputDecoration(
        hintText: '000000',
        hintStyle: TextStyle(
          color: textFieldColor,
          letterSpacing: 8,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(
          Icons.security,
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
      maxLength: 6,
      buildCounter: (context,
          {required currentLength, required isFocused, maxLength}) {
        return Text(
          '$currentLength/${maxLength ?? 6}',
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 12,
          ),
        );
      },
    );
  }

  Widget _buildVerifyButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (codeController.text.trim().isEmpty) {
                  Get.snackbar(
                    'Verification Code Required',
                    'Please enter the verification code.',
                    backgroundColor: Colors.orange[100],
                    colorText: Colors.orange[800],
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                try {
                  bool success =
                      await verifyUserEmail(codeController.text.trim());

                  if (success) {
                    Get.snackbar(
                      'Email Verified!',
                      'Your email has been successfully verified.',
                      backgroundColor: Colors.green[100],
                      colorText: Colors.green[800],
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );

                    // Navigate to the main page after successful verification
                    Get.offAll(() => YouTubeVideoPage());
                  } else {
                    Get.snackbar(
                      'Verification Failed',
                      'Invalid verification code. Please try again.',
                      backgroundColor: Colors.red[100],
                      colorText: Colors.red[800],
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  }
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'An error occurred during verification',
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[800],
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
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
                'Verify Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildResendCodeButton(bool isSmallScreen) {
    return TextButton(
      onPressed: () {
        // Implement resend code functionality
        Get.snackbar(
          'Code Sent',
          'A new verification code has been sent to your email.',
          backgroundColor: Colors.blue[100],
          colorText: Colors.blue[800],
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
      child: Text(
        'Resend verification code',
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}
