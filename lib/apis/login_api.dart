import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class LoginApis extends BaseUrl {
  Future<Response> login(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('user/login', data: data);
      return response; // Return the response for further handling
    } catch (e) {
      // Handle errors (e.g., network issues, server errors)
      throw Exception('Failed to login: $e');
    }
  }
}
