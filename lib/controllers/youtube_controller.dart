import 'package:dio/dio.dart';
import '../apis/youtube_api.dart';
import '../Model/youtube_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YouTubeVideoController {
  List<YouTubeVideo> videos = [];
  List<YouTubeVideo> myvideos = [];
  List<YouTubeVideo> adminvideos = [];

  Future<bool> fetchVideos() async {
    final youtubeVideoApi = YoutubeApi();
    try {
      final response = await youtubeVideoApi.getAllVideos();
      if (response.statusCode == 200) {
        videos = (response.data as List)
            .map((videoJson) => YouTubeVideo.fromJson(videoJson))
            .toList();
        return true;
      } else {
        print('Failed to fetch videos: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> fetchmyVideos() async {
    final youtubeVideoApi = YoutubeApi();
    try {
      final response = await youtubeVideoApi.myVideos();
      if (response.statusCode == 200) {
        myvideos = (response.data as List)
            .map((videoJson) => YouTubeVideo.fromJson(videoJson))
            .toList();
        return true;
      } else {
        print('Failed to fetch videos: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> fetchVideosadmin() async {
    final youtubeVideoApi = YoutubeApi();
    try {
      final response = await youtubeVideoApi.getAllVideosadmin();
      if (response.statusCode == 200) {
        adminvideos = (response.data as List)
            .map((videoJson) => YouTubeVideo.fromJson(videoJson))
            .toList();
        return true;
      } else {
        print('Failed to fetch videos: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> createVideo({
    required String youtubeURL,
    required String videoName,
    String? message,
  }) async {
    final youtubeVideoApi = YoutubeApi();
    try {
      final response = await youtubeVideoApi.createVideo(
        youtubeURL: youtubeURL,
        videoName: videoName,
        message: message,
      );

      if (response.statusCode == 201) {
        // Optionally refresh the video list
        await fetchVideos();
        return true;
      } else {
        print('Failed to create video: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred while creating video: $e');
      return false;
    }
  }

  Future<void> updateVideoStatus(String videoId, String newStatus) async {
    final youtubeVideoApi = YoutubeApi();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userRole = prefs.getString('role');

      // Check if user is admin
      if (userRole != 'admin') {
        throw Exception('Only admins can update video status');
      }

      final response = await youtubeVideoApi.updateVideoStatus(
        videoId: videoId,
        status: newStatus,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update video status');
      }

      // Update local state if needed
      final index = videos.indexWhere((v) => v.id == videoId);
      if (index != -1) {
        videos[index] = YouTubeVideo.fromJson(response.data['video']);
      }
    } catch (e) {
      print('Error updating video status: $e');
      rethrow;
    }
  }
}
