import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 
class NotificationItem extends StatelessWidget {
  final String name;
  final String description;
  final String date;
  final int numOfLikes;
  final String profileImageUrl;
  final String postImage;
 
  const NotificationItem({
    super.key,
    required this.name,
    required this.description,
    required this.date,
    required this.numOfLikes,
    this.profileImageUrl = '',
    this.postImage = '',
  });
 
  bool _isNetworkImage(String image) {
    return image.startsWith('http://') ||
        image.startsWith('https://');
  }
 
  ImageProvider? _imageProvider(String image) {
    if (image.trim().isEmpty) {
      return null;
    }
 
    if (_isNetworkImage(image)) {
      return CachedNetworkImageProvider(image);
    }
 
    return AssetImage(image);
  }
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 10.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _imageProvider(profileImageUrl),
            child: profileImageUrl.trim().isEmpty
                ? const Icon(
                    Icons.person,
                    color: Colors.black,
                  )
                : null,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface,
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' ',
                      ),
                      TextSpan(
                        text: description,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (postImage.trim().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _isNetworkImage(postImage)
                  ? CachedNetworkImage(
                      imageUrl: postImage,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorWidget: (
                        context,
                        url,
                        error,
                      ) {
                        return Container(
                          width: 48,
                          height: 48,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.broken_image,
                            size: 20,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      postImage,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
            ),
        ],
      ),
    );
  }
}