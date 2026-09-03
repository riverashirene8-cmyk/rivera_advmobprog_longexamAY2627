import 'package:flutter/material.dart';
 
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/storage_service.dart';
import '../services/user_service.dart';
import '../widgets/post_card.dart';
import 'detail_screen.dart';
 
class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});
 
  @override
  State<NewsFeedScreen> createState() => NewsFeedScreenState();
}
 
class NewsFeedScreenState extends State<NewsFeedScreen> {
  final PostService _postService = PostService();
 
  final UserService _userService = UserService();
 
  final ScrollController _scrollController = ScrollController();
 
  final List<PostItem> _posts = [];
  final Map<int, AppUser> _usersById = {};
 
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
 
  int _skip = 0;
  final int _limit = 10;
 
  static List<PostItem> filterPostsForUsers(
    List<PostItem> posts,
    Map<int, AppUser> usersById,
  ) {
    return posts.where((post) => usersById.containsKey(post.userId)).toList();
  }
 
  @override
  void initState() {
    super.initState();
 
    _scrollController.addListener(_onScroll);
 
    _initializeFeed();
  }
 
  Future<void> _initializeFeed() async {
    await _loadUsers();
    await _loadInitialPosts();
  }
 
  Future<void> _loadUsers() async {
    try {
      final users = await _userService.getUsers(limit: 100);
 
      if (!mounted) return;
 
      setState(() {
        _usersById.clear();
        for (final user in users) {
          _usersById[user.id] = user;
        }
      });
    } catch (_) {
      // Ignore user loading errors and keep the post fallback.
    }
  }
 
  Future<void> _loadInitialPosts() async {
    setState(() {
      _loading = true;
      _skip = 0;
      _posts.clear();
      _hasMore = true;
    });
 
    try {
      final posts = await _postService.getPosts(limit: _limit, skip: 0);
 
      if (!mounted) return;
 
      setState(() {
        final validPosts = filterPostsForUsers(posts, _usersById);
 
        _posts.addAll(validPosts);
        _skip = posts.length;
        _hasMore = posts.length == _limit;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
 
      setState(() {
        _loading = false;
      });
 
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load posts')));
    }
  }
 
  void _onScroll() {
    if (_scrollController.position.extentAfter < 400) {
      _loadMore();
    }
  }
 
  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore || _loading) {
      return;
    }
 
    setState(() {
      _loadingMore = true;
    });
 
    try {
      final posts = await _postService.getPosts(limit: _limit, skip: _skip);
 
      if (!mounted) return;
 
      setState(() {
        final validPosts = filterPostsForUsers(posts, _usersById);
 
        _posts.addAll(validPosts);
        _skip += posts.length;
        _hasMore = posts.length == _limit;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
 
      setState(() {
        _loadingMore = false;
      });
    }
  }
 
  Future<void> refreshFeed() async {
    await _loadUsers();
    await _loadInitialPosts();
  }
 
  Future<void> _showCreatePostDialog() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final messenger = ScaffoldMessenger.maybeOf(context);
    final user = await StorageService.getAuthUser();
 
    if (!mounted || user == null) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
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
                  decoration: const InputDecoration(hintText: 'Title'),
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
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
 
    if (result != true) {
      return;
    }
 
    final title = titleController.text.trim();
    final body = bodyController.text.trim();
 
    if (body.isEmpty) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Post body cannot be empty')),
      );
      return;
    }
 
    try {
      final newPost = await _postService.createPost(
        userId: user.id,
        title: title.isEmpty ? 'New post' : title,
        body: body,
      );
 
      if (!mounted) return;
 
      setState(() {
        _posts.insert(0, newPost);
      });
 
      messenger?.showSnackBar(const SnackBar(content: Text('Post created')));
    } catch (_) {
      if (!mounted) return;
 
      messenger?.showSnackBar(
        const SnackBar(content: Text('Failed to create post')),
      );
    }
  }
 
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
 
    final feed = RefreshIndicator(
      onRefresh: refreshFeed,
      child: _posts.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 250),
                Center(child: Text('No posts available')),
              ],
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _posts.length + (_loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
 
                final post = _posts[index];
                final author = _usersById[post.userId];
 
                final userName = 'User ${author?.id ?? 'Unknown'}';
 
                return PostCard(
                  key: ValueKey(post.id),
                  postId: post.id,
                  userName: userName,
                  postContent: post.body,
                  numOfLikes: post.likes,
                  date: post.createdAt,
                  postImage: post.images.isNotEmpty ? post.images.first : null,
                  profileImage: author?.image ?? '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(
                          postId: post.id,
                          userId: post.userId,
                          userName: userName,
                          postContent: post.body,
                          date: post.createdAt,
                          numOfLikes: post.likes,
                          numOfDislikes: post.dislikes,
                          imageUrl: post.images.isNotEmpty
                              ? post.images.first
                              : '',
                          profileImageUrl: author?.image ?? '',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
 
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: _showCreatePostDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: feed,
    );
  }
}
 