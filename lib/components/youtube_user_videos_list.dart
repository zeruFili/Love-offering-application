import 'package:flutter/material.dart';
import '../Model/youtube_model.dart';
import 'youtube_user_video_card.dart';

class YouTubeUserVideosList extends StatelessWidget {
  final List<YouTubeVideo> videos;
  final Function(YouTubeVideo) onGiftPressed;

  const YouTubeUserVideosList({
    super.key,
    required this.videos,
    required this.onGiftPressed,
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
        return YouTubeUserVideoCard(
          video: video,
          onGiftPressed: onGiftPressed,
        );
      },
    );
  }
}
