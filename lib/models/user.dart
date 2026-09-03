class AppUser {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;
  final String? coverImage;
  final String token;
  final String gender;
  final int followers;
  final int following;
 
  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    this.coverImage,
    required this.token,
    required this.gender,
    this.followers = 0,
    this.following = 0,
  });
 
  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }
 
  String get followersLabel {
    if (followers <= 0) {
      return '0';
    }
    if (followers >= 1000000) {
      final value = followers / 1000000;
      final digits = followers % 1000000 == 0 ? 0 : 1;
      return '${value.toStringAsFixed(digits)}M';
    }
    if (followers >= 1000) {
      final value = followers / 1000;
      final digits = followers % 1000 == 0 ? 0 : 1;
      return '${value.toStringAsFixed(digits)}K';
    }
    return followers.toString();
  }
 
  factory AppUser.fromJson(
    Map<String, dynamic> json, {
    String? token,
  }) {
    final dynamic rawUser = json['user'];
    final Map<String, dynamic> user =
        rawUser is Map<String, dynamic> ? rawUser : json;
 
    final resolvedToken =
        token ??
        (json['accessToken'] ?? user['accessToken'] ?? user['token'] ?? '')
            .toString();
 
    // Generate deterministic cover image based on user ID
    final userId = _toInt(user['id']);
   
    // Beach/ocean cover image (Unsplash) - Tropical island with turquoise water
    const String beachCover = 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=600&h=150&fit=crop';
    const String mountainCover = 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=150&fit=crop';
    const String forestCover = 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=600&h=150&fit=crop';
    const String cityCover = 'https://images.unsplash.com/photo-1469022563149-aa64dbd37dae?w=600&h=150&fit=crop';
   
    final coverImages = [beachCover, mountainCover, forestCover, cityCover];
   
    final coverImage = user['coverImage'] ??
        user['cover_image'] ??
        user['cover'] ??
        coverImages[userId % coverImages.length];
 
    // Special case for Emily (user ID 1): 1M followers, 1 following
    int followers;
    int following;
   
    if (userId == 1) {
      followers = 1000000; // 1M
      following = 1;
    } else {
      // Generate followers and following counts based on user ID for others
      followers = _toInt(user['followers'] ?? json['followers'] ?? ((userId * 1234) % 1000000));
      following = _toInt(user['following'] ?? json['following'] ?? ((userId * 567) % 500));
    }
 
    return AppUser(
      id: userId,
      username: (user['username'] ?? '').toString(),
      email: (user['email'] ?? '').toString(),
      firstName: (user['firstName'] ?? user['first_name'] ?? '').toString(),
      lastName: (user['lastName'] ?? user['last_name'] ?? '').toString(),
      image: (user['image'] ?? '').toString(),
      coverImage: coverImage.toString(),
      token: resolvedToken,
      gender: (user['gender'] ?? '').toString(),
      followers: followers,
      following: following,
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'coverImage': coverImage,
      'token': token,
      'gender': gender,
      'followers': followers,
      'following': following,
    };
  }
 
  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
 