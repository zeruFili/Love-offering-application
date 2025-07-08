class YouTubeVideo {
  final String id;
  final String name;
  final String youtubeURL;
  final String videoName;
  final String? message;
  final String status;

  YouTubeVideo({
    required this.id,
    required this.name,
    required this.youtubeURL,
    required this.videoName,
    this.message,
    required this.status,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      id: json['_id'] as String? ?? '', // Handle both _id and potential null
      name: json['name'] as String? ?? '',
      youtubeURL: json['youtubeURL'] as String? ?? '',
      videoName: json['videoName'] as String? ?? '',
      message: json['message'] as String?,
      status:
          json['status'] as String? ?? 'pending', // Default to pending if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'youtubeURL': youtubeURL,
      'videoName': videoName,
      'message': message,
      'status': status,
    };
  }
}
