class PostItem {
  final int id;
  final int userId;
  final String title;
  final String body;
  final List<String> images;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final String createdAt;

  const PostItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.images,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
  });

  factory PostItem.fromJson(Map<String, dynamic> json) {
    final dynamic rawImages = json['images'];
    final dynamic rawTags = json['tags'];
    final dynamic reactions = json['reactions'];

    int likes = 0;
    int dislikes = 0;

    if (reactions is Map) {
      likes = _toInt(reactions['likes']);
      dislikes = _toInt(reactions['dislikes']);
    } else {
      likes = _toInt(json['likes']);
      dislikes = _toInt(json['dislikes']);
    }

    return PostItem(
      // ENHANCEMENT 3:
      // Use the post ID to identify which comments belong to the post.
      id: _toInt(json['id']),

      userId: _toInt(
        json['userId'] ?? json['user_id'],
      ),

      title: (json['title'] ?? '').toString(),

      body: (json['body'] ?? '').toString(),

      images: rawImages is List
          ? rawImages.map((e) => e.toString()).toList()
          : <String>[],

      tags: rawTags is List
          ? rawTags.map((e) => e.toString()).toList()
          : <String>[],

      likes: likes,
      dislikes: dislikes,

      createdAt: (
        json['createdAt'] ??
        json['created_at'] ??
        json['date'] ??
        ''
      ).toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}