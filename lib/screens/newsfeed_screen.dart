import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      PostCard(
        userName: 'Marceline the Vampire',
        postContent: '♡✧˚ ༘ ⋆｡♡˚',
        numOfLikes: 214,
        date: 'October 11',
        postImage: 'assets/images/post.avif',
        profileImage: 'assets/images/marceline.jpg',
      ),
      PostCard(
        userName: 'Shirene Rivera',
        postContent: 'movie date with this girl ♡',
        numOfLikes: 385,
        date: 'December 2',
        postImage: 'assets/images/AT.avif',
        profileImage: 'assets/images/Profile.jpg',
      ),
      PostCard(
        userName: 'Bherli Sison',
        postContent: 'Doing my shoot today',
        numOfLikes: 1000,
        date: 'May 30',
        postImage: 'assets/images/post5.jpg',
        profileImage: 'assets/images/bherliane.jpg',
      ),
      PostCard(
        userName: 'Cyrell Romero',
        postContent: 'morning ride',
        numOfLikes: 550,
        date: 'November 8',
        postImage: 'assets/images/post6.jpg',
        profileImage: 'assets/images/yumyum.webp',
      ),
      PostCard(
        userName: 'Lorenzo Limjoco',
        postContent: 'night out',
        numOfLikes: 200,
        date: 'January 8',
        postImage: 'assets/images/post7.jpg',
        profileImage: 'assets/images/lorenzo.jpg',
      ),
    ];

    // Enhancement 1: Alternate NewsFeed post and Advertisement post (3–4 times)
    final List<Widget> feed = [];
    for (int i = 0; i < posts.length; i++) {
      feed.add(posts[i]);

      // insert ads after the first 4 posts (3–4 alternations)
      if (i < 4) {
        feed.add(const _AdvertisementSection());
      }
    }

    return ListView(
      children: feed,
    );
  }
}

class _AdvertisementSection extends StatelessWidget {
  const _AdvertisementSection();

  static const List<Map<String, String>> ads = [
    {
      'title': 'MORE DETAILS',
      'subtitle': 'Limited Edition!',
      'image': 'https://melissalinford2019.home.blog/wp-content/uploads/2019/07/the-ad-i-wanna-use.jpg',
    },
    {
      'title': 'MORE DETAILS',
      'subtitle': 'New Product',
      'image': 'https://i.ytimg.com/vi/SWVPBZ_5YRE/maxresdefault.jpg',
    },
    {
      'title': 'MORE DETAILS',
      'subtitle': 'New drop!',
      'image': 'https://i.pinimg.com/474x/74/cd/0d/74cd0d744b289241d6c14d7d2b8370b9.jpg',
    },
    {
      'title': 'MORE DETAILS',
      'subtitle': 'Sale alert',
      'image': 'https://cdn.prod.website-files.com/63a9fb94e473f36dbe99c1b1/6721eb7f26a3abad8150992b_670f9fd1db969b82e51ddac9_651bc96c3a63a9a0b05c6812_gVjhZDMuTFScETxfsOb1.jpeg',
    },
    {
      'title': 'MORE DETAILS',
      'subtitle': 'Best deals',
      'image': 'https://mindesigns.com.au/wp-content/uploads/2024/07/82546073_10158492387896412_102606704276930560_n-1024x1024.jpg',
    },
    {
      'title': 'MORE DETAILS',
      'subtitle': 'Try this now',
      'image': 'https://neilpatel.com/wp-content/uploads/2023/01/Food_advertisments12.jpg',
    },
  ];

  bool _isNetwork(String path) {
    final p = path.trim();
    final uri = Uri.tryParse(p);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhancement 2: Title above the items
            const Text(
              'Advertisement/Promotion',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Enhancement 2: 5–7 items
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ads.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = ads[index];
                  final img = (item['image'] ?? '').trim();

                  return SizedBox(
                    width: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _isNetwork(img)
                                ? CachedNetworkImage(
                                    imageUrl: img,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey.shade300,
                                      alignment: Alignment.center,
                                      child: const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey.shade300,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image),
                                    ),
                                  )
                                : Image.asset(
                                    img,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.grey.shade300,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item['subtitle']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200,
                              ),
                              child: const Icon(Icons.arrow_forward, size: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
