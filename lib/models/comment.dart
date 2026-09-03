// ENHANCEMENT 3:
// Define the comment data model used to display comments for each post.
class CommentItem {
  final int id;
  final int postId;
  final int userId;
  final String body;
  final String username;
  final String fullName;
  final String avatar;
  final DateTime createdAt;

  const CommentItem({
    required this.id,
    required this.postId,
    required this.userId,
    required this.body,
    required this.username,
    required this.fullName,
    required this.avatar,
    required this.createdAt,
  });

  // ENHANCEMENT 3:
  // Convert the Comments API response into a CommentItem object.
  factory CommentItem.fromJson(Map<String, dynamic> json) {
    final dynamic rawUser = json['user'];

    final Map<String, dynamic> user =
        rawUser is Map<String, dynamic> ? rawUser : {};

    final timestamp =
        json['date'] ??
        json['createdAt'] ??
        DateTime.now().toIso8601String();

    var firstName = (
      user['firstName'] ??
      user['first_name'] ??
      json['firstName'] ??
      json['first_name'] ??
      ''
    ).toString().trim();

    var lastName = (
      user['lastName'] ??
      user['last_name'] ??
      json['lastName'] ??
      json['last_name'] ??
      ''
    ).toString().trim();

    if (firstName.isEmpty && lastName.isEmpty) {
      final fullNameField = (
        user['fullName'] ??
        json['fullName'] ??
        ''
      ).toString().trim();

      if (fullNameField.isNotEmpty) {
        final parts = fullNameField.split(' ');

        if (parts.length > 1) {
          firstName = parts.first;
          lastName = parts.skip(1).join(' ');
        } else {
          firstName = fullNameField;
        }
      }
    }

    final fullName = '$firstName $lastName'.trim().isEmpty
        ? (user['username'] ?? json['username'] ?? 'User').toString()
        : '$firstName $lastName'.trim();

    return CommentItem(
      id: _toInt(json['id']),

      // ENHANCEMENT 3:
      // Store the post ID to associate the comment with its post.
      postId: _toInt(
        json['postId'] ?? json['post_id'],
      ),

      userId: _toInt(
        json['userId'] ??
            json['user_id'] ??
            user['id'],
      ),

      body: (json['body'] ?? '').toString(),

      username: (
        user['username'] ??
        json['username'] ??
        'User'
      ).toString(),

      fullName: fullName,

      avatar: (
        user['image'] ??
        json['avatar'] ??
        ''
      ).toString(),

      createdAt: timestamp is DateTime
          ? timestamp
          : DateTime.tryParse(
                timestamp.toString(),
              ) ??
              DateTime.now(),
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