import 'package:flutter/material.dart';
import '../widgets/custom_info.dart' as notif;

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            notif.NotificationItem(
              name: 'Marceline',
              description: 'commented on your photo',
              date: 'December 8',
              numOfLikes: 3,
              profileImageUrl: 'assets/images/marceline.jpg',
              postImage: 'assets/images/friends.webp',
            ),
            const Divider(indent: 70, endIndent: 16),
 notif.NotificationItem(
              name: 'Marceline',
              description: 'commented on your photo',
              date: 'December 10',
              numOfLikes: 3,
              profileImageUrl: 'assets/images/marceline.jpg',
              postImage: 'assets/images/bff.jpg',
            ),
            const Divider(indent: 70, endIndent: 16),

            notif.NotificationItem(
              name: 'Bherli Sison',
              description: 'shared your post',
              date: 'December 4',
              numOfLikes: 8,
              profileImageUrl: 'assets/images/bherliane.jpg',
              postImage: 'assets/images/unicorn.jpg',
            ),
            const Divider(indent: 70, endIndent: 16),

            notif.NotificationItem(
              name: 'Cyrell Romero',
              description: 'reacted 👍 to your post',
              date: 'December 3',
              numOfLikes: 20,
              profileImageUrl: 'assets/images/yumyum.webp',
              postImage: 'assets/images/bff.jpg',
            ),
            const Divider(indent: 70, endIndent: 16),
             notif.NotificationItem(
              name: 'Lorenzo Limjoco',
              description: 'reacted 👍 to your post',
              date: 'December 5',
              numOfLikes: 20,
              profileImageUrl: 'assets/images/lorenzo.jpg',
              postImage: 'assets/images/friends.webp',
            ),
            const Divider(indent: 70, endIndent: 16),
             notif.NotificationItem(
              name: 'Bherli Sison',
              description: 'shared your post',
              date: 'December 9',
              numOfLikes: 8,
              profileImageUrl: 'assets/images/bherliane.jpg',
              postImage: 'assets/images/bff.jpg',
            ),
            const Divider(indent: 70, endIndent: 16),
             notif.NotificationItem(
              name: 'Cyrell Romero',
              description: 'shared your post',
              date: 'December 7',
              numOfLikes: 8,
              profileImageUrl: 'assets/images/yumyum.webp',
              postImage: 'assets/images/friends.webp',
            ),
            const Divider(indent: 70, endIndent: 16),
             notif.NotificationItem(
              name: 'Cyrell Romero',
              description: 'commented on your photo',
              date: 'December 8',
              numOfLikes: 3,
              profileImageUrl: 'assets/images/yumyum.webp',
              postImage: 'assets/images/unicorn.jpg',
            ),
            const Divider(indent: 70, endIndent: 16),
 notif.NotificationItem(
              name: 'Bherli Sison',
              description: 'mentioned you in post',
              date: 'December 11',
              numOfLikes: 8,
              profileImageUrl: 'assets/images/bherliane.jpg',
              postImage: 'assets/images/post.avif',
            ),
          ],
        ),
      ),
    );
  }
}
