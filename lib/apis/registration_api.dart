import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class RegistrationApis extends BaseUrl {
  Future<Response> register(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('/user/signup', data: data);
      return response; // Return the response for handling
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
