import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class YoutubeApi extends BaseUrl {
  Future<Response> getAllVideos() async {
    try {
      final response = await dio.get('videos'); // Adjust the endpoint as needed
      return response; // Return the response for further handling
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  Future<Response> myVideos() async {
    try {
      final response =
          await dio.get('videos/my'); // Adjust the endpoint as needed
      return response; // Return the response for further handling
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  Future<Response> getAllVideosadmin() async {
    try {
      final response =
          await dio.get('videos/all'); // Adjust the endpoint as needed
      return response; // Return the response for further handling
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  Future<Response> createVideo({
    required String youtubeURL,
    required String videoName,
    String? message,
  }) async {
    try {
      final response = await dio.post(
        'videos',
        data: {
          'youtubeURL': youtubeURL,
          'videoName': videoName,
          'message': message,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create video: $e');
    }
  }

  Future<Response> updateVideoStatus({
    required String videoId,
    required String status,
  }) async {
    try {
      return await dio.patch(
        'videos/$videoId',
        data: {'status': status},
      );
    } catch (e) {
      throw Exception('Failed to update video status: $e');
    }
  }
}
