import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_button.dart';
import '../widgets/post_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatelessWidget {
  final String displayName;

  const ProfileScreen({super.key, required this.displayName});

  static List<String> photoList = [
    'https://cdn.dribbble.com/userupload/15575029/file/original-0e6a01ce3727e2b4022b3fdd1e495156.png?resize=752x&vertical=center',
    'https://i.pinimg.com/originals/79/e2/73/79e2731d19545acae8bf88055eea8158.png',
    'https://wallpapercave.com/wp/wp10562461.jpg',
    'https://wallpapercave.com/wp/wp10562461.jpg',
    'https://www.tripsavvy.com/thmb/ENcqAjtXtH3XNV3eIg4MKfSyQ6A=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-135558476-8533a33260d9436c9bc432ce630ec732.jpg',
    'assets/images/friends.webp',
    'assets/images/unicorn.jpg',
  ];

  ImageProvider _imgProvider(String path) {
    if (path.startsWith('http')) {
      return CachedNetworkImageProvider(path);
    }
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    const coverPath =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNW_w7n7enFz966hE4I_qSlw-JUmZMWRn0_g&s';
    const avatarPath =
        'https://m.media-amazon.com/images/M/MV5BZWQxMzUxMDItNGM1Ny00YTU4LWJkYmQtOThhYmU3YjY0YzI0XkEyXkFqcGc@._V1_.jpg';

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          /// HEADER SECTION
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// COVER PHOTO
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _imgProvider(coverPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// AVATAR (OVERLAP)
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundImage: _imgProvider(avatarPath),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: fbPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// NAME + FOLLOWERS + BUTTONS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: displayName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10),

                        /// FOLLOWERS / FOLLOWING (NUMBERS BOLD)
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            children: const [
                              TextSpan(
                                text: '500k ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: 'followers • '),
                              TextSpan(
                                text: '320 ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: 'following'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            SizedBox(
                              height: 36,
                              child: CustomButton(
                                buttonName: 'Follow',
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 36,
                              child: CustomButton(
                                buttonName: 'Message',
                                buttonType: 'outlined',
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// TAB BAR
                const TabBar(
                  indicatorColor: fbPrimary,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    Tab(text: 'Posts'),
                    Tab(text: 'About'),
                    Tab(text: 'Photos'),
                  ],
                ),
              ],
            ),
          ),

          /// CONTENT AREA
          Expanded(
            child: Container(
              color: fbSecondary,
              child: TabBarView(
                children: [
                  /// POSTS TAB
                  ListView(
                    padding: const EdgeInsets.only(top: 8),
                    children: [
                      PostCard(
                        userName: displayName,
                        postContent: 'movie date with this girl ♡',
                        numOfLikes: 200,
                        date: 'December 2',
                        postImage: 'assets/images/AT.avif',
                        profileImage: 'assets/images/Profile.jpg',
                      ),
                      PostCard(
                        userName: displayName,
                        postContent: 'singing together make us happy ♬',
                        numOfLikes: 359,
                        date: 'December 2',
                        postImage: 'assets/images/post2.webp',
                        profileImage: 'assets/images/Profile.jpg',
                      ),
                      PostCard(
                        userName: displayName,
                        postContent: 'cute',
                        numOfLikes: 400,
                        date: 'December 2',
                        postImage: 'assets/images/post3.jpg',
                        profileImage: 'assets/images/Profile.jpg',
                      ),
                      PostCard(
                        userName: displayName,
                        postContent: 'good morning 𝗓ᶻ',
                        numOfLikes: 325,
                        date: 'December 2',
                        postImage: 'assets/images/post4.jpg',
                        profileImage: 'assets/images/Profile.jpg',
                      ),
                      PostCard(
                        userName: displayName,
                        postContent: 'bonding ♡',
                        numOfLikes: 210,
                        date: 'December 2',
                        postImage: 'assets/images/bff.jpg',
                        profileImage: 'assets/images/Profile.jpg',
                      ),
                      PostCard(
                        userName: displayName,
                        postContent: 'my family ♡♡♡',
                        numOfLikes: 720,
                        date: 'December 2',
                        postImage: 'assets/images/friends.webp',
                        profileImage: 'assets/images/Profile.jpg',
                      ),
                      PostCard(
                        userName: displayName,
                        postContent: 'my bestfriend',
                        numOfLikes: 240,
                        date: 'December 2',
                        postImage: 'assets/images/unicorn.jpg',
                        profileImage: 'assets/images/Profile.jpg',
                      ),
                    ],
                  ),

                  /// ABOUT TAB 
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Me',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text('🎓 Studies at National University'),
                          SizedBox(height: 8),
                          Text('❤️ In a Relationship'),
                          SizedBox(height: 8),
                          Text('👨‍👩‍👧‍👦 Family Oriented'),
                          SizedBox(height: 8),
                          Text('☕ Coffee Lover'),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      itemCount: photoList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                      itemBuilder: (context, index) {
                        final path = photoList[index];
                        final isNetwork = path.startsWith('http');

                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  titlePadding: const EdgeInsets.fromLTRB(
                                    16,
                                    12,
                                    8,
                                    0,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                  content: SizedBox(
                                    height: 300,
                                    width: double.infinity,
                                    child: Center(
                                      child: isNetwork
                                          ? CachedNetworkImage(
                                              imageUrl: path,
                                              fit: BoxFit.contain,
                                              progressIndicatorBuilder:
                                                  (
                                                    context,
                                                    url,
                                                    downloadProgress,
                                                  ) =>
                                                      CircularProgressIndicator(
                                                        color: fbPrimary,
                                                        value: downloadProgress
                                                            .progress,
                                                      ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                        Icons.error,
                                                        size: 60,
                                                      ),
                                            )
                                          : Image.asset(
                                              path,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.error,
                                                    size: 60,
                                                  ),
                                            ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: isNetwork
                                ? CachedNetworkImage(
                                    imageUrl: path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(path, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
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
