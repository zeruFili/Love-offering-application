import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class UserApi extends BaseUrl {
  Future<Response> getAllUsers() async {
    try {
      final response = await dio.get('user'); // Adjust the endpoint as needed
      return response; // Return the response for further handling
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}
