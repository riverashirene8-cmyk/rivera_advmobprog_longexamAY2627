import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import '../widgets/post_card.dart';
import 'detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String displayName;

  const ProfileScreen({
    super.key,
    required this.displayName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PostService _postService = PostService();

  AppUser? _user;
  bool _loading = true;

  List<PostItem> _posts = [];

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  Future<void> _loadUser() async {
    // ENHANCEMENT 2:
    // Retrieve the currently authenticated user so that
    // the user's ID can be used to load their posts.
    final user = await StorageService.getAuthUser();

    if (!mounted) return;

    setState(() {
      _user = user;
    });

    if (user != null) {
      // ENHANCEMENT 2:
      // Load posts using the authenticated user's userID.
      await _loadPosts(user.id);
    }

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  Future<void> _loadPosts(int userId) async {
    try {
      // ENHANCEMENT 2:
      // Request only posts associated with the selected userID.
      final posts = await _postService.getPostsByUserId(userId);

      if (!mounted) return;

      setState(() {
        _posts = posts;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _posts = [];
      });
    }
  }

  Future<void> _showCreatePostDialog() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    // Retrieve the current authenticated user.
    final user = await StorageService.getAuthUser();

    if (!mounted || user == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text('Please log in first'),
          ),
        );
      }

      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Post'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: bodyController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'What do you want to share?',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text('Post'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final title = titleController.text.trim();
    final body = bodyController.text.trim();

    if (body.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post body cannot be empty'),
        ),
      );

      return;
    }

    try {
      // ENHANCEMENT 2:
      // Create a new post using the authenticated user's userID.
      final newPost = await _postService.createPost(
        userId: user.id,
        title: title.isEmpty ? 'New post' : title,
        body: body,
      );

      if (!mounted) return;

      setState(() {
        _posts.insert(0, newPost);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create post'),
        ),
      );
    }
  }

  ImageProvider? _imageProvider(String path) {
    if (path.trim().isEmpty) {
      return null;
    }

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return CachedNetworkImageProvider(path);
    }

    return AssetImage(path);
  }

  static const String _defaultCover =
      'assets/images/AT.avif';

  String get _coverImage {
    final cover = _user?.coverImage ?? '';

    if (cover.isNotEmpty) {
      return cover;
    }

    return _defaultCover;
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        _user?.fullName ?? widget.displayName;

    final avatar = _user?.image ?? '';

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: _showCreatePostDialog,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: fbSecondary,
                    child: _coverImage.isEmpty
                        ? Image.asset(
                            'assets/images/NUCCITLogo_Black.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                Container(
                              color: fbSecondary,
                            ),
                          )
                        : _coverImage.startsWith('assets/')
                            ? Image.asset(
                                _coverImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    Container(
                                  color: fbSecondary,
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: _coverImage,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Container(
                                  color: fbSecondary,
                                ),
                                errorWidget:
                                    (_, __, ___) =>
                                        Container(
                                  color: fbSecondary,
                                ),
                              ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, -35),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                      ),
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor:
                            Colors.grey.shade300,
                        backgroundImage:
                            _imageProvider(avatar),
                        child: avatar.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 40,
                              )
                            : null,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      15,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: userName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '@${_user?.username ?? ''}',
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Text(
                              '${_user?.followersLabel ?? '0'} ',
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                                color: fbPrimary,
                              ),
                            ),
                            const Text('followers'),

                            const SizedBox(width: 20),

                            Text(
                              '${_user?.following ?? 0} ',
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                                color: fbPrimary,
                              ),
                            ),
                            const Text('following'),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            SizedBox(
                              height: 36,
                              child: CustomButton(
                                buttonName: 'Follow',
                                fontColor: Colors.white,
                                onPressed: () {},
                              ),
                            ),

                            const SizedBox(width: 10),

                            SizedBox(
                              height: 36,
                              child: CustomButton(
                                buttonName: 'Message',
                                fontColor: Colors.white,
                                outlineColor: fbPrimary,
                                onPressed: () {
                                  showMessagingUnavailableDialog(
                                    context,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const TabBar(
                    indicatorColor: fbPrimary,
                    tabs: [
                      Tab(text: 'Posts'),
                      Tab(text: 'About'),
                      Tab(text: 'Photos'),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildPostsTab(),
                  _buildAboutTab(),
                  _buildPhotosTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_posts.isEmpty) {
      return const Center(
        child: Text('No posts available'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (_user != null) {
          // ENHANCEMENT 2:
          // Refresh the posts using the authenticated user's userID.
          await _loadPosts(_user!.id);
        }
      },

      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];

          final authorName =
              _user?.fullName ?? widget.displayName;

          // ENHANCEMENT 2:
          // Render the posts retrieved for the current user.
          return PostCard(
            key: ValueKey(post.id),
            postId: post.id,
            userName: authorName,
            postContent: post.body,
            numOfLikes: post.likes,
            date: post.createdAt,
            postImage: post.images.isNotEmpty
                ? post.images.first
                : null,
            profileImage: _user?.image ?? '',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(
                    postId: post.id,
                    userId: _user?.id ?? 0,
                    userName: authorName,
                    postContent: post.body,
                    date: post.createdAt,
                    numOfLikes: post.likes,
                    imageUrl:
                        post.images.isNotEmpty
                            ? post.images.first
                            : '',
                    profileImageUrl:
                        _user?.image ?? '',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAboutTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Username: ${_user?.username ?? 'N/A'}',
                ),

                const SizedBox(height: 10),

                Text(
                  'Email: ${_user?.email ?? 'N/A'}',
                ),

                const SizedBox(height: 10),

                Text(
                  'Gender: ${_user?.gender.isNotEmpty == true ? _user!.gender : 'N/A'}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosTab() {
    final photos = _posts
        .expand((post) => post.images)
        .where((image) => image.isNotEmpty)
        .toList();

    if (photos.isEmpty) {
      return const Center(
        child: Text('No photos available'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: photos.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final image = photos[index];

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            errorWidget: (_, _, _) =>
                const Icon(Icons.broken_image),
          ),
        );
      },
    );
  }
}