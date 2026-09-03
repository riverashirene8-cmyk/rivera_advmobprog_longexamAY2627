import 'package:flutter/material.dart';
 
import '../constants.dart';
import '../services/comment_service.dart';
import '../services/post_service.dart';
import '../services/storage_service.dart';
import '../services/user_service.dart';
import 'detail_screen.dart';
 
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
 
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}
 
class _NotificationScreenState extends State<NotificationScreen> {
  final PostService _postService = PostService();
  final CommentService _commentService = CommentService();
  final UserService _userService = UserService();
 
  final Map<int, dynamic> _usersById = {};
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;
 
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }
 
  Future<void> _showCreatePostDialog() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final user = await StorageService.getAuthUser();
 
    if (!mounted || user == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please log in first')));
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
 
    if (result != true) return;
 
    final title = titleController.text.trim();
    final body = bodyController.text.trim();
 
    if (body.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post body cannot be empty')),
      );
      return;
    }
 
    try {
      await _postService.createPost(
        userId: user.id,
        title: title.isEmpty ? 'New post' : title,
        body: body,
      );
 
      if (!mounted) return;
 
      await _loadNotifications();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post created')));
    } catch (_) {
      if (!mounted) return;
 
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create post')));
    }
  }
 
  Future<void> _loadNotifications() async {
    final user = await StorageService.getAuthUser();
 
    if (!mounted) return;
 
    try {
      final users = await _userService.getUsers(limit: 100);
      if (!mounted) return;
 
      setState(() {
        _usersById.clear();
        for (final u in users) {
          _usersById[u.id] = u;
        }
      });
    } catch (_) {
      // Ignore user loading failure and continue showing notification items.
    }
 
    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }
 
    try {
      final posts = await _postService.getPosts(limit: 30, skip: 0);
      final notifications = <Map<String, dynamic>>[];
 
      for (final post in posts.where((item) => item.userId == user.id)) {
        notifications.add({
          'name': 'User ${user.id}',
          'text': 'You created a post.',
          'date': 'Today',
          'avatar': user.image,
          'postId': post.id,
          'post': post,
        });
 
        if (post.likes > 0) {
          notifications.add({
            'name': 'Unknown user',
            'text': 'A user reacted to your post.',
            'date': 'Today',
            'avatar': '',
            'postId': post.id,
            'post': post,
          });
        }
 
        final comments = await _commentService.getCommentsByPost(post.id);
 
        for (final comment in comments.where(
          (item) => item.userId != user.id,
        )) {
          final commenter = await _userService.getUserById(comment.userId);
 
          notifications.add({
            'name': commenter?.id != null ? 'User ${commenter!.id}' : comment.username,
            'text': 'commented on your post: "${comment.body}"',
            'date': 'Today',
            'avatar': commenter?.image ?? comment.avatar,
            'postId': post.id,
            'post': post,
          });
        }
      }
 
      for (final post in posts.where((item) => item.userId != user.id)) {
        final comments = await _commentService.getCommentsByPost(post.id);
 
        for (final _ in comments.where((item) => item.userId == user.id)) {
          final poster = await _userService.getUserById(post.userId);
 
          notifications.add({
            'name': 'User ${user.id}',
            'text':
                'You commented on ${poster?.id != null ? 'User ${poster!.id}' : 'this user'}\'s post.',
            'date': 'Today',
            'avatar': user.image,
            'postId': post.id,
            'post': post,
          });
        }
      }
 
      if (!mounted) return;
 
      setState(() {
        _notifications = notifications;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
 
      setState(() {
        _notifications = [
          {
            'name': 'User ${user.id}',
            'text': 'You created a post.',
            'date': 'Today',
            'avatar': user.image,
            'postId': 0,
          },
        ];
        _loading = false;
      });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: fbPrimary));
    }
 
    final content = _notifications.isEmpty
        ? const Center(
            child: Text(
              'No notifications yet',
              style: TextStyle(color: fbPrimary),
            ),
          )
        : ListView.separated(
            itemCount: _notifications.length,
            separatorBuilder: (_, _) => const Divider(indent: 70),
            itemBuilder: (context, index) {
              final item = _notifications[index];
              final postId = item['postId'] as int?;
              final post = item['post'];
 
              return ListTile(
                onTap: postId != null && postId > 0 && post != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(
                              postId: post.id,
                              userId: post.userId,
                              userName: 'User ${post.userId}',
                              postContent: post.body,
                              date: post.createdAt ?? 'Today',
                              numOfLikes: post.likes ?? 0,
                              numOfDislikes: post.dislikes ?? 0,
                              imageUrl: post.images.isNotEmpty ? post.images[0] : '',
                              profileImageUrl: _usersById[post.userId]?.image ?? '',
                            ),
                          ),
                        );
                      }
                    : null,
                leading: CircleAvatar(
                  backgroundColor: fbPrimary,
                  child: const Icon(Icons.message_rounded, color: Colors.white),
                ),
                title: Text(
                  item['name'] ?? 'User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: fbPrimary,
                  ),
                ),
                subtitle: Text(
                  item['text'] ?? '',
                  style: const TextStyle(color: fbPrimary),
                ),
                trailing: Text(
                  item['date'] ?? 'Today',
                  style: const TextStyle(fontSize: 11, color: fbSecondary),
                ),
              );
            },
          );
 
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: _showCreatePostDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: content,
    );
  }
}