import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_endpoints.dart';

class AuthService {
  // Get token from SharedPreferences
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Check authentication function
  Future<bool> checkAuth() async {
    try {
      final String? token = await getToken();

      if (token == null) {
        print('No token found. User is not authenticated.');
        return false;
      }

      final response = await http.get(
        Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.checkAuth}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
