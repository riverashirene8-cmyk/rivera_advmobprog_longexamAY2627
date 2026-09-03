import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
 
import '../models/comment.dart';
import '../services/comment_service.dart';
import '../services/storage_service.dart';
import '../services/user_service.dart';
import 'custom_font.dart';
import 'post_action_button.dart';
 
class PostCard extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String? postImage;
  final String? profileImage;
  final int? postId;
  final VoidCallback? onTap;
 
  const PostCard({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    this.numOfLikes = 0,
    this.postImage,
    this.profileImage,
    this.postId,
    this.onTap,
  });
 
  @override
  State<PostCard> createState() => _PostCardState();
}
 
class _PostCardState extends State<PostCard> {
  final CommentService _commentService = CommentService();
  final UserService _userService = UserService();
 
  final TextEditingController _commentController = TextEditingController();
 
  final FocusNode _commentFocusNode = FocusNode();
 
  int _likes = 0;
  bool _isLiked = false;
 
  bool _loadingComments = false;
 
  List<CommentItem> _comments = [];
  final Map<int, String> _userFullNames = {};
 
  @override
  void initState() {
    super.initState();
 
    _likes = widget.numOfLikes;
 
    _loadComments();
  }
 
  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
 
    super.dispose();
  }
 
  Future<void> _loadComments() async {
    if (widget.postId == null) {
      return;
    }
 
    setState(() {
      _loadingComments = true;
    });
 
    try {
      final comments = await _commentService.getCommentsByPost(widget.postId!);
 
      if (!mounted) return;
 
      // Fetch user full names for comments that don't have them
      for (final comment in comments) {
        if (comment.fullName == comment.username && comment.fullName.isNotEmpty) {
          try {
            final user = await _userService.getUserById(comment.userId);
            if (user != null) {
              _userFullNames[comment.userId] = user.fullName;
            }
          } catch (_) {
            // Ignore errors fetching individual users
          }
        }
      }
 
      if (!mounted) return;
 
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      if (!mounted) return;
 
      setState(() {
        _comments = [];
      });
    }
 
    if (!mounted) return;
 
    setState(() {
      _loadingComments = false;
    });
  }
 
  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
 
    if (text.isEmpty || widget.postId == null) {
      return;
    }
 
    try {
      final user = await StorageService.getAuthUser();
 
      if (!mounted) return;
 
      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
        return;
      }
 
      final comment = await _commentService.addComment(
        postId: widget.postId!,
        userId: user.id,
        body: text,
      );
 
      if (!mounted) return;
 
      setState(() {
        _comments.insert(0, comment);
      });
 
      _commentController.clear();
 
      FocusScope.of(context).unfocus();
 
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Comment added')));
    } catch (e) {
      if (!mounted) return;
 
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to add comment')));
    }
  }
 
  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likes--;
 
        if (_likes < 0) {
          _likes = 0;
        }
      } else {
        _likes++;
      }
 
      _isLiked = !_isLiked;
    });
  }
 
  void _focusComment() {
    FocusScope.of(context).requestFocus(_commentFocusNode);
  }
 
  void _sharePost() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Post shared')));
  }
 
  bool _isNetwork(String? image) {
    if (image == null || image.trim().isEmpty) {
      return false;
    }
 
    return image.startsWith('http://') || image.startsWith('https://');
  }
 
  Widget _profileImage() {
    if (widget.profileImage == null || widget.profileImage!.trim().isEmpty) {
      return const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      );
    }
 
    if (_isNetwork(widget.profileImage)) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: CachedNetworkImageProvider(widget.profileImage!),
      );
    }
 
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: AssetImage(widget.profileImage!),
    );
  }
 
  Widget _postImage() {
    final image = widget.postImage;
 
    if (image == null || image.trim().isEmpty) {
      return const SizedBox.shrink();
    }
 
    if (_isNetwork(image)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: image,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Container(
              height: 220,
              color: Colors.grey.shade300,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorWidget: (context, url, error) {
            return Container(
              height: 220,
              color: Colors.grey.shade300,
              child: const Icon(Icons.broken_image),
            );
          },
        ),
      );
    }
 
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        image,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 220,
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image),
          );
        },
      ),
    );
  }
 
  Widget _buildComment(CommentItem comment) {
    final body = comment.body;
    final displayName = _userFullNames[comment.userId] ??
        (comment.fullName.isNotEmpty ? comment.fullName : comment.username);
 
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(body, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
 
    final card = Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USER HEADER
            Row(
              children: [
                _profileImage(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: widget.userName,
                        fontSize: 15,
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          CustomFont(
                            text: widget.date,
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.public,
                            size: 13,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
 
            const SizedBox(height: 10),
 
            // POST CONTENT
            CustomFont(
              text: widget.postContent,
              fontSize: 13,
              color: theme.colorScheme.onSurface,
            ),
 
            const SizedBox(height: 10),
 
            // POST IMAGE
            if (widget.postImage != null && widget.postImage!.trim().isNotEmpty)
              _postImage(),
 
            const SizedBox(height: 8),
 
            // LIKE COUNT
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.thumb_up,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                Text('$_likes', style: const TextStyle(fontSize: 12)),
                const Spacer(),
                Text(
                  'comment (${_comments.length})',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
 
            const Divider(),
 
            // ACTION BUTTONS
            Row(
              children: [
                PostActionButton(
                  icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                  label: 'Like',
                  color: _isLiked ? Colors.blue : theme.colorScheme.onSurface,
                  onTap: _toggleLike,
                ),
                PostActionButton(
                  icon: Icons.comment_outlined,
                  label: 'Comment',
                  onTap: _focusComment,
                ),
                PostActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: _sharePost,
                ),
              ],
            ),
 
            const SizedBox(height: 8),
 
            // COMMENT FIELD
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submitComment(),
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _submitComment,
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
 
            const SizedBox(height: 10),
 
            // VIEW COMMENTS LINK
            if (_comments.isNotEmpty && widget.onTap != null)
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  'View comments',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
 
            const SizedBox(height: 8),
 
            // COMMENTS
            if (_loadingComments)
              const Padding(
                padding: EdgeInsets.all(10),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (_comments.isNotEmpty)
              Column(children: _comments.take(3).map(_buildComment).toList())
            else
              const Text(
                'No comments yet.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),
    );
 
    if (widget.onTap == null) {
      return card;
    }
 
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: card,
      ),
    );
  }
}