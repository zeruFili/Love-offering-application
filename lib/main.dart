import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/checkauth_controller.dart';
import 'utils/api_endpoints.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/YouTubeVideopage.dart';
import 'pages/emailverify_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authController = AuthService();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Navigation',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: ApiEndPoints.registerEmail, page: () => RegisterScreen()),
        GetPage(name: ApiEndPoints.loginEmail, page: () => LoginScreen()),
        GetPage(
            name: ApiEndPoints.verifyEmail,
            page: () => EmailVerificationScreen()),
        GetPage(
            name: ApiEndPoints.home,
            page: () => YouTubeVideoPage()), // Update the home page route
      ],
      home: FutureBuilder<bool>(
        future: authController.checkAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!) {
            return YouTubeVideoPage(); // Set YouTubeVideoPage for authenticated users
          } else {
            return YouTubeVideoPage(); // Navigate to login if not authenticated
          }
        },
      ),
    );
  }
}
