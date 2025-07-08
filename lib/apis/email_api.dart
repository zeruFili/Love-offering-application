import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apis/base_api.dart';

class EmailApi extends BaseUrl {
  Future<Response> verifyEmail(String code) async {
    try {
      final response =
          await dio.post('user/verify-email', data: {'code': code});
      return response; // Return the response for further handling
    } catch (e) {
      // Handle errors (e.g., network issues, server errors)
      throw Exception('Failed to verify email: $e');
    }
  }
}
