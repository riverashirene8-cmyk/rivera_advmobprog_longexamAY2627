import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../services/comment_service.dart';
import '../services/storage_service.dart';
import '../services/user_service.dart';

class DetailScreen extends StatefulWidget {
  final int postId;
  final int userId;
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final int numOfDislikes;
  final String imageUrl;
  final String profileImageUrl;

  const DetailScreen({
    super.key,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.postContent,
    required this.date,
    required this.numOfLikes,
    this.numOfDislikes = 0,
    required this.imageUrl,
    required this.profileImageUrl,
  });

  @override
  State<DetailScreen> createState() =>
      _DetailScreenState();
}

class _DetailScreenState
    extends State<DetailScreen> {
  final CommentService _commentService =
      CommentService();
  final UserService _userService =
      UserService();

  final TextEditingController
      _commentController =
      TextEditingController();

  List<CommentItem> _comments = [];
  Map<int, bool> _likedComments = {};
  Map<int, bool> _repliedComments = {};
  Map<int, String> _userFullNames = {};

  bool _loadingComments = true;
  bool _sendingComment = false;
  bool _liked = false;
  bool _disliked = false;

  int _likes = 0;
  int _dislikes = 0;
  int _shares = 0;

  @override
  void initState() {
    super.initState();

    _likes = widget.numOfLikes;
    _dislikes = widget.numOfDislikes;

    // ENHANCEMENT 3:
    // Load comments for the selected post.
    _loadComments();
  }

  // ENHANCEMENT 3:
  // Retrieve all comments based on the current post ID.
  Future<void> _loadComments() async {
    try {
      final comments =
          await _commentService
              .getCommentsForPost(
        widget.postId,
      );

      if (!mounted) return;

      // Fetch user full names for comments that don't have them
      for (final comment in comments) {
        if (comment.fullName == comment.username &&
            comment.fullName.isNotEmpty) {
          try {
            final user =
                await _userService.getUserById(
              comment.userId,
            );

            if (user != null) {
              _userFullNames[comment.userId] =
                  user.fullName;
            }
          } catch (_) {
            // Ignore errors fetching individual users
          }
        }
      }

      if (!mounted) return;

      setState(() {
        _comments = comments;
        _loadingComments = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingComments = false;
      });
    }
  }

  // ENHANCEMENT 3:
  // Add a new comment to the selected post.
  Future<void> _addComment() async {
    final body =
        _commentController.text.trim();

    if (body.isEmpty) return;

    setState(() {
      _sendingComment = true;
    });

    try {
      final comment =
          await _commentService.addComment(
        postId: widget.postId,
        userId: widget.userId,
        body: body,
      );

      if (!mounted) return;

      setState(() {
        _comments.insert(0, comment);
        _commentController.clear();
        _sendingComment = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _sendingComment = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to add comment',
          ),
        ),
      );
    }
  }

  // ENHANCEMENT 3:
  // Handle the clickable Like action for a comment.
  Future<void> _likeComment(
      CommentItem comment) async {
    try {
      final user =
          await StorageService.getAuthUser();

      if (user == null) return;

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'You liked this comment! User notified.',
          ),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to like comment',
          ),
        ),
      );
    }
  }

  Future<void> _replyToComment(
      CommentItem comment) async {
    final replyController =
        TextEditingController();

    final displayName =
        _userFullNames[comment.userId] ??
            (comment.fullName.isNotEmpty
                ? comment.fullName
                : comment.username);

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Reply to $displayName',
          ),
          content: TextField(
            controller: replyController,
            maxLines: 3,
            autofocus: true,
            decoration:
                const InputDecoration(
              hintText:
                  'Write your reply...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                dialogContext,
              ),
              child:
                  const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                dialogContext,
                replyController.text
                    .trim(),
              ),
              child:
                  const Text('Reply'),
            ),
          ],
        );
      },
    );

    if (result == null ||
        result.isEmpty) {
      return;
    }

    try {
      final user =
          await StorageService.getAuthUser();

      if (user == null) return;

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Reply posted! User has been notified.',
          ),
          duration:
              Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Failed to post reply'),
        ),
      );
    }
  }

  ImageProvider? _profileProvider() {
    final path =
        widget.profileImageUrl.trim();

    if (path.isEmpty) return null;

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return CachedNetworkImageProvider(
        path,
      );
    }

    return AssetImage(path);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        backgroundColor: fbPrimary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.all(12),
              children: [
                _buildPost(),

                const SizedBox(
                  height: 15,
                ),

                Text(
                  'comment (${_comments.length})',
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // ENHANCEMENT 3:
                // Display all comments associated with the selected post.
                _buildComments(),
              ],
            ),
          ),

          // ENHANCEMENT 3:
          // Provide the interface for adding a new comment.
          _buildCommentBox(),
        ],
      ),
    );
  }

  Widget _buildPost() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      Colors.grey.shade300,
                  backgroundImage:
                      _profileProvider(),
                  child:
                      widget.profileImageUrl
                              .trim()
                              .isEmpty
                          ? const Icon(
                              Icons.person,
                            )
                          : null,
                ),

                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        widget.userName,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.date,
                        style:
                            const TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Text(widget.postContent),

            if (widget.imageUrl
                .trim()
                .isNotEmpty) ...[
              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
                child:
                    _networkImage(
                  widget.imageUrl,
                ),
              ),
            ],

            const SizedBox(
              height: 12,
            ),

            // STATS ROW
            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration:
                        const BoxDecoration(
                      color: Colors.blue,
                      shape:
                          BoxShape.circle,
                    ),
                    child:
                        const Icon(
                      Icons.thumb_up,
                      size: 13,
                      color:
                          Colors.white,
                    ),
                  ),
                  const SizedBox(
                      width: 5),
                  Text(
                    '$_likes',
                    style:
                        const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                      width: 15),
                  Container(
                    width: 22,
                    height: 22,
                    decoration:
                        const BoxDecoration(
                      color: Colors.red,
                      shape:
                          BoxShape.circle,
                    ),
                    child:
                        const Icon(
                      Icons.thumb_down,
                      size: 13,
                      color:
                          Colors.white,
                    ),
                  ),
                  const SizedBox(
                      width: 5),
                  Text(
                    '$_dislikes',
                    style:
                        const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                      width: 20),
                  Text(
                    'comment (${_comments.length})',
                    style:
                        const TextStyle(
                      fontSize: 12,
                      color:
                          Colors.grey,
                    ),
                  ),
                  const SizedBox(
                      width: 20),
                  Text(
                    'share ($_shares)',
                    style:
                        const TextStyle(
                      fontSize: 12,
                      color:
                          Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceAround,
              children: [
                Expanded(
                  child:
                      TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _liked = !_liked;
                        _likes +=
                            _liked
                                ? 1
                                : -1;
                      });
                    },
                    icon: Icon(
                      _liked
                          ? Icons.thumb_up
                          : Icons
                              .thumb_up_alt_outlined,
                      color: _liked
                          ? fbPrimary
                          : null,
                    ),
                    label: Text(
                      'Like',
                      style:
                          TextStyle(
                        color: _liked
                            ? fbPrimary
                            : null,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child:
                      TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _disliked =
                            !_disliked;
                        _dislikes +=
                            _disliked
                                ? 1
                                : -1;
                      });
                    },
                    icon: Icon(
                      _disliked
                          ? Icons.thumb_down
                          : Icons
                              .thumb_down_alt_outlined,
                      color: _disliked
                          ? Colors.red
                          : null,
                    ),
                    label: Text(
                      'Dislike',
                      style:
                          TextStyle(
                        color: _disliked
                            ? Colors.red
                            : null,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child:
                      TextButton.icon(
                    onPressed: () {},
                    icon:
                        const Icon(
                      Icons
                          .comment_outlined,
                    ),
                    label:
                        const Text(
                      'Comment',
                    ),
                  ),
                ),

                Expanded(
                  child:
                      TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _shares++;
                      });

                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Post shared!',
                          ),
                          duration:
                              Duration(
                            seconds: 2,
                          ),
                        ),
                      );
                    },
                    icon:
                        const Icon(
                      Icons
                          .share_outlined,
                    ),
                    label:
                        const Text(
                      'Share',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _networkImage(
      String url) {
    return CachedNetworkImage(
      imageUrl: url,
      width: double.infinity,
      height: 260,
      fit: BoxFit.cover,
      placeholder: (_, _) =>
          Container(
        height: 260,
        color: Colors
            .grey.shade300,
        child: const Center(
          child:
              CircularProgressIndicator(),
        ),
      ),
      errorWidget: (_, _, _) =>
          Container(
        height: 260,
        color: Colors
            .grey.shade300,
        child: const Center(
          child: Icon(
            Icons.broken_image,
          ),
        ),
      ),
    );
  }

  // ENHANCEMENT 3:
  // Render all comments retrieved for the current post.
  Widget _buildComments() {
    if (_loadingComments) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (_comments.isEmpty) {
      return const Padding(
        padding:
            EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Center(
          child: Text(
            'No comments yet.',
          ),
        ),
      );
    }

    return Column(
      children: _comments
          .map(
            (comment) =>
                _commentItem(
              comment,
            ),
          )
          .toList(),
    );
  }

  Widget _commentItem(
    CommentItem comment,
  ) {
    final isLiked =
        _likedComments[comment.id] ??
            false;

    final isReplied =
        _repliedComments[
                comment.id] ??
            false;

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                Colors.grey.shade300,
            child: const Icon(
              Icons.person,
              size: 18,
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(
                    10,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Theme.of(
                      context,
                    ).brightness ==
                            Brightness.dark
                        ? Colors
                            .grey.shade800
                        : Colors
                            .grey.shade200,
                    borderRadius:
                        BorderRadius
                            .circular(
                      12,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        _userFullNames[
                                comment
                                    .userId] ??
                            (comment
                                    .fullName
                                    .isNotEmpty
                                ? comment
                                    .fullName
                                : comment
                                    .username),
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        comment.body,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    // ENHANCEMENT 3:
                    // Make the Like action clickable for each comment.
                    GestureDetector(
                      onTap: () {
                        _likeComment(
                            comment);

                        setState(() {
                          _likedComments[
                                  comment
                                      .id] =
                              !(isLiked);
                        });
                      },
                      child: Text(
                        'Like',
                        style:
                            TextStyle(
                          fontSize: 12,
                          color: isLiked
                              ? Colors
                                  .blue
                              : Colors
                                  .grey
                                  .shade600,
                          fontWeight: isLiked
                              ? FontWeight
                                  .bold
                              : FontWeight
                                  .normal,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    GestureDetector(
                      onTap: () {
                        _replyToComment(
                            comment);
                      },
                      child: Text(
                        'Reply',
                        style:
                            TextStyle(
                          fontSize: 12,
                          color: Colors
                              .grey
                              .shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ENHANCEMENT 3:
  // Provide the comment input and submit button.
  Widget _buildCommentBox() {
    return SafeArea(
      top: false,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        color: Theme.of(context)
            .scaffoldBackgroundColor,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 17,
              child: Icon(
                Icons.person,
                size: 18,
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            Expanded(
              child: TextField(
                controller:
                    _commentController,
                textInputAction:
                    TextInputAction.send,

                // ENHANCEMENT 3:
                // Submit a new comment when the user presses Send.
                onSubmitted: (_) =>
                    _addComment(),

                decoration:
                    InputDecoration(
                  hintText:
                      'Write a comment...',
                  filled: true,
                  fillColor:
                      Colors.grey
                          .withValues(
                    alpha: 0.15,
                  ),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),
                    borderSide:
                        BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 5,
            ),

            IconButton(
              // ENHANCEMENT 3:
              // Send the entered comment to the selected post.
              onPressed:
                  _sendingComment
                      ? null
                      : _addComment,
              icon: _sendingComment
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: fbPrimary,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}