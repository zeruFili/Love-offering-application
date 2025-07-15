import 'package:flutter/material.dart';
import '../Model/youtube_model.dart';
import '../utils/youtube_utils.dart';
import 'youtube_video_card.dart';

class YouTubeVideosList extends StatelessWidget {
  final List<YouTubeVideo> videos;
  final bool isAdmin;
  final Color Function(String) getStatusColor;
  final Future<void> Function(YouTubeVideo, String) onUpdateVideoStatus;

  const YouTubeVideosList({
    super.key,
    required this.videos,
    required this.isAdmin,
    required this.getStatusColor,
    required this.onUpdateVideoStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return YouTubeVideoCard(
          video: video,
          isAdmin: isAdmin,
          getStatusColor: getStatusColor,
          onUpdateVideoStatus: onUpdateVideoStatus,
        );
      },
    );
  }
}
