import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatelessWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;

  // Your PostCard passes these and says "expects NETWORK images"
  final String imageUrl;
  final String profileImageUrl;

  const DetailScreen({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    required this.numOfLikes,
    required this.imageUrl,
    required this.profileImageUrl,
  });

  bool _isNetwork(String? path) {
    final p = path?.trim() ?? '';
    final uri = Uri.tryParse(p);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  ImageProvider? _provider(String? path) {
    final p = path?.trim();
    if (p == null || p.isEmpty) return null;
    if (_isNetwork(p)) return CachedNetworkImageProvider(p);
    return AssetImage(p);
  }

  Widget _imageWidget(String? path, {double? height}) {
    final p = path?.trim();
    if (p == null || p.isEmpty) return const SizedBox.shrink();

    if (_isNetwork(p)) {
      return CachedNetworkImage(
        imageUrl: p,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey.shade300),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: height,
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      );
    }

    // Fallback if you ever pass assets
    return Image.asset(
      p,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => Container(
        width: double.infinity,
        height: height,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Post',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _provider(profileImageUrl),
                        child: (profileImageUrl.trim().isEmpty)
                            ? const Icon(Icons.person, color: Colors.black)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.public,
                                    size: 14, color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_horiz),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // CONTENT
                  Text(
                    postContent,
                    style: const TextStyle(fontSize: 13),
                  ),

                  // IMAGE
                  if (imageUrl.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _imageWidget(imageUrl, height: 260),
                    ),
                  ],

                  const SizedBox(height: 10),

                  // LIKES
                  Text(
                    '$numOfLikes likes',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ACTIONS (simple UI)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _Action(icon: Icons.thumb_up_alt_outlined, label: 'Like'),
                      _Action(icon: Icons.comment_outlined, label: 'Comment'),
                      _Action(icon: Icons.share_outlined, label: 'Share'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // COMMENT BOX
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _provider(profileImageUrl),
                        child: (profileImageUrl.trim().isEmpty)
                            ? const Icon(Icons.person,
                                size: 18, color: Colors.black)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text(
                            'Write a comment...',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Action({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
