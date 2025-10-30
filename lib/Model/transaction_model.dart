class Transaction {
  final String id;
  final String? videoId;
  final String? artistId;
  final String supporterId;
  final double amount;
  final String? description;
  final bool supporterViewed;
  final bool artistViewed;
  final Payment payment;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Populated fields (from populate)
  final Video? video;
  final User? artist;
  final User? supporter;

  Transaction({
    required this.id,
    this.videoId,
    this.artistId,
    required this.supporterId,
    required this.amount,
    this.description,
    required this.supporterViewed,
    required this.artistViewed,
    required this.payment,
    required this.createdAt,
    this.updatedAt,
    this.video,
    this.artist,
    this.supporter,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      videoId: json['video'] is String ? json['video'] : json['video']?['_id'],
      artistId:
          json['artist'] is String ? json['artist'] : json['artist']?['_id'],
      supporterId: json['supporter'] is String
          ? json['supporter']
          : json['supporter']?['_id'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      supporterViewed: json['supporterViewed'] ?? false,
      artistViewed: json['artistViewed'] ?? false,
      payment: Payment.fromJson(json['payment'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      video: json['video'] is Map ? Video.fromJson(json['video']) : null,
      artist: json['artist'] is Map ? User.fromJson(json['artist']) : null,
      supporter:
          json['supporter'] is Map ? User.fromJson(json['supporter']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video': videoId,
      'artist': artistId,
      'supporter': supporterId,
      'amount': amount,
      'description': description,
      'supporterViewed': supporterViewed,
      'artistViewed': artistViewed,
      'payment': payment.toJson(),
    };
  }
}

class Payment {
  final double amount;
  final String currency;
  final String transactionId;

  Payment({
    required this.amount,
    required this.currency,
    required this.transactionId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      transactionId: json['transactionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'transactionId': transactionId,
    };
  }
}

class Video {
  final String id;
  final String videoName;
  final String youtubeURL;
  final String? message;
  final String status;

  Video({
    required this.id,
    required this.videoName,
    required this.youtubeURL,
    this.message,
    required this.status,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'] ?? '',
      videoName: json['videoName'] ?? '',
      youtubeURL: json['youtubeURL'] ?? '',
      message: json['message'],
      status: json['status'] ?? 'pending',
    );
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}
