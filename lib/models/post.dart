enum PostType { text, image, video }

enum PostStatus { pending, approved, rejected }

class Post {
  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.type,
    required this.status,
    required this.createdAt,
    this.body = '',
    this.mediaUrl,
    this.adminReply,
    this.adminRepliedAt,
    this.adminRepliedBy,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String authorEmail;
  final PostType type;
  final PostStatus status;
  final DateTime createdAt;
  final String body;
  final String? mediaUrl;
  final String? adminReply;
  final DateTime? adminRepliedAt;
  final String? adminRepliedBy;

  Post copyWith({
    PostStatus? status,
    String? adminReply,
    DateTime? adminRepliedAt,
    String? adminRepliedBy,
  }) {
    return Post(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorEmail: authorEmail,
      type: type,
      status: status ?? this.status,
      createdAt: createdAt,
      body: body,
      mediaUrl: mediaUrl,
      adminReply: adminReply ?? this.adminReply,
      adminRepliedAt: adminRepliedAt ?? this.adminRepliedAt,
      adminRepliedBy: adminRepliedBy ?? this.adminRepliedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorEmail': authorEmail,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'body': body,
      'mediaUrl': mediaUrl,
      'adminReply': adminReply,
      'adminRepliedAt': adminRepliedAt?.toIso8601String(),
      'adminRepliedBy': adminRepliedBy,
    };
  }

  factory Post.fromMap(String id, Map<String, dynamic> map) {
    return Post(
      id: id,
      authorId: map['authorId'] as String? ?? '',
      authorName: map['authorName'] as String? ?? 'Anonymous',
      authorEmail: map['authorEmail'] as String? ?? '',
      type: PostType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PostType.text,
      ),
      status: PostStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PostStatus.pending,
      ),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      body: map['body'] as String? ?? '',
      mediaUrl: map['mediaUrl'] as String?,
      adminReply: map['adminReply'] as String?,
      adminRepliedAt:
          DateTime.tryParse(map['adminRepliedAt'] as String? ?? ''),
      adminRepliedBy: map['adminRepliedBy'] as String?,
    );
  }
}
