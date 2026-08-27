import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/detail_screen.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.name,
    required this.description,
    required this.date,
    required this.numOfLikes,
    this.profileImageUrl = '',
    this.postImage = '',
  });

  final String name;
  final String description;
  final String date;
  final int numOfLikes;
  final String profileImageUrl;
  final String postImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(
              userName: name,
              postContent: description,
              date: date,
              numOfLikes: numOfLikes,
              imageUrl: postImage,
              profileImageUrl: profileImageUrl,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 10.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE AVATAR (LEFT)
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: profileImageUrl.isNotEmpty
                  ? AssetImage(profileImageUrl)
                  : null,
              child: profileImageUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.black)
                  : null,
            ),

            SizedBox(width: 10.w),

            /// TEXT (MIDDLE)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                      children: [
                        TextSpan(
                          text: name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(text: description),
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

            /// POST THUMBNAIL (RIGHT)
            if (postImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  postImage,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
