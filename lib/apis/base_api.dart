import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseUrl {
  Dio dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000/api/',
    // Remove the default Content-Type header here
  ));

  BaseUrl() {
    dio.interceptors.add(LogInterceptor(responseBody: true, request: true));

    // Add an interceptor to set headers before each request
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Only set JSON content type if not multipart
        if (options.data is! FormData) {
          options.headers['Content-Type'] = 'application/json';
        }

        // Handle authentication token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        print(token);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          options.headers.remove('Authorization');
        }
        return handler.next(options);
      },
    ));
  }
}
