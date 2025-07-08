import 'package:shared_preferences/shared_preferences.dart';
import '../apis/email_api.dart';

Future<bool> verifyUserEmail(String code) async {
  final emailApi = EmailApi();

  try {
    final response = await emailApi.verifyEmail(code);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      // Check if the response has the expected structure
      if (data['user'] == null) {
        print('User data is missing in response');
        return false;
      }

      final user = data['user'] as Map<String, dynamic>;

      // Validate required fields
      if (user['_id'] == null ||
          user['first_name'] == null ||
          user['last_name'] == null ||
          user['email'] == null ||
          user['accessToken'] == null) {
        print('Missing required user data in response');
        return false;
      }

      final String accessToken = user['accessToken'] as String;
      final String name = '${user['first_name']} ${user['last_name']}';

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', accessToken);
      await prefs.setString('name', name);
      await prefs.setString('email', user['email'] as String);
      await prefs.setString('user_id', user['_id'] as String);

      return true;
    } else {
      print('Failed to verify email. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error during email verification: $e');
    return false;
  }
}
