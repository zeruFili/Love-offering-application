import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../Model/youtube_model.dart';
import '../utils/youtube_utils.dart';
import '../pages/youtube_user_player_screen.dart';

class YouTubeUserVideoCard extends StatelessWidget {
  final YouTubeVideo video;
  final Function(YouTubeVideo) onGiftPressed;

  const YouTubeUserVideoCard({
    super.key,
    required this.video,
    required this.onGiftPressed,
  });

  void _playVideo(BuildContext context, YouTubeVideo video) {
    final videoId = extractYoutubeId(video.youtubeURL);
    if (videoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid YouTube URL')),
      );
      return;
    }

    final youtubeController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
        enableCaption: true,
      ),
    );

    youtubeController.loadVideoById(videoId: videoId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubeUserPlayerScreen(
          controller: youtubeController,
          video: video,
          onGiftPressed: () => onGiftPressed(video),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoId = extractYoutubeId(video.youtubeURL);
    final thumbnailUrl = videoId.isNotEmpty
        ? 'https://img.youtube.com/vi/$videoId/mqdefault.jpg'
        : null;

    return GestureDetector(
      onTap: () => _playVideo(context, video),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: const Color(0xFFF7F8FA),
                    child: thumbnailUrl != null
                        ? Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF0A5D4A)),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.video_library,
                                  size: 64,
                                  color: Color(0xFF9CA3AF),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.video_library,
                              size: 64,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Play',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.videoName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'By ${video.name}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () => onGiftPressed(video),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7E6),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFFFD700),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.card_giftcard,
                                size: 14,
                                color: Color(0xFFFFA500),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Gift',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFFFA500),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
