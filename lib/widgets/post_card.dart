import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rivera_mobprog/widgets/custom_font.dart';
import 'package:rivera_mobprog/widgets/post_action_button.dart';
import 'package:rivera_mobprog/screens/detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostCard extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String? postImage;
  final String? profileImage;

  // ✅ AD SUPPORT
  final bool isAd;
  final String adButtonText;

  const PostCard({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    this.postImage,
    this.profileImage,
    this.numOfLikes = 0,
    this.isAd = false,
    this.adButtonText = 'MORE DETAILS',
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likes;
  bool _isLiked = false;

  // ✅ NEW: force a visible loader for a short time
  bool _showLoader = true;
  Timer? _loaderTimer;

  @override
  void initState() {
    super.initState();
    _likes = widget.numOfLikes;

    _loaderTimer = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _showLoader = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _loaderTimer?.cancel();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likes--;
      } else {
        _likes++;
      }
      _isLiked = !_isLiked;
    });
  }

  bool _isNetwork(String? path) {
    final p = path?.trim() ?? '';
    final uri = Uri.tryParse(p);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  ImageProvider? _avatarProvider(String? img) {
    final p = img?.trim();
    if (p == null || p.isEmpty) return null;
    if (_isNetwork(p)) return CachedNetworkImageProvider(p);
    return AssetImage(p);
  }

  Widget _forcedSpinnerPlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _postImageWidget(String path) {
    final p = path.trim();

    if (_isNetwork(p)) {
      // ✅ NEW: show spinner for at least 350ms, even if cached/fast
      if (_showLoader) {
        return SizedBox(
          width: double.infinity,
          height: 220,
          child: _forcedSpinnerPlaceholder(),
        );
      }

      return CachedNetworkImage(
        imageUrl: p,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        placeholder: (context, url) => _forcedSpinnerPlaceholder(),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      );
    }

    return Image.asset(
      p,
      width: double.infinity,
      height: 220,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(
              userName: widget.userName,
              postContent: widget.postContent,
              date: widget.date,
              numOfLikes: _likes,
              imageUrl: widget.postImage ?? '',
              profileImageUrl: widget.profileImage ?? '',
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _avatarProvider(widget.profileImage),
                    child: (widget.profileImage == null ||
                            (widget.profileImage?.trim().isEmpty ?? true))
                        ? const Icon(Icons.person, color: Colors.black)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: widget.userName,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          CustomFont(
                            text: widget.date,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.public, size: 14, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz),
                ],
              ),

              const SizedBox(height: 6),

              if (widget.isAd) ...[
                const SizedBox(height: 4),
                const Text(
                  'Advertisement/Promotion',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
              ],

              /// POST CONTENT
              CustomFont(
                text: widget.postContent,
                fontSize: 12,
                color: Colors.black,
              ),

              /// POST/AD IMAGE
              if (widget.postImage != null &&
                  (widget.postImage?.trim().isNotEmpty ?? false)) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: _postImageWidget(widget.postImage!),
                ),
              ],

              const SizedBox(height: 8),

              if (widget.isAd) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.adButtonText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, size: 14),
                      ],
                    ),
                  ),
                ),
              ],

              if (!widget.isAd) ...[
                const SizedBox(height: 6),

                /// ACTION BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _toggleLike,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_alt_outlined,
                              size: 18,
                              color: _isLiked ? Colors.blue : Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_likes',
                              style: TextStyle(
                                fontSize: 12,
                                color: _isLiked ? Colors.blue : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PostActionButton(
                      icon: Icons.comment_outlined,
                      label: 'Comment',
                      onTap: () {},
                    ),
                    PostActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// COMMENT INPUT
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _avatarProvider(widget.profileImage),
                      child: (widget.profileImage == null ||
                              (widget.profileImage?.trim().isEmpty ?? true))
                          ? const Icon(Icons.person,
                              size: 16, color: Colors.black)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Write a comment...',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                CustomFont(
                  text: 'View comments',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
