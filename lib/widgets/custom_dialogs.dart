import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
 
import 'custom_font.dart';
 
const Color _primaryColor = Color(0xFF1877F2);
 
void customDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      );
    },
  );
}
 
void customOptionDialog(
  BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onYes,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: CustomFont(
          text: title,
          fontSize: 22,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        content: CustomFont(
          text: content,
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onYes();
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
 
void showMessagingUnavailableDialog(
  BuildContext context,
) {
  customDialog(
    context,
    title: 'Messaging',
    content: 'This feature is not available yet.',
  );
}
 
void customShowImageDialog(
  BuildContext context, {
  required String imageUrl,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SizedBox(
          height: 300,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              progressIndicatorBuilder: (
                context,
                url,
                progress,
              ) {
                return CircularProgressIndicator(
                  value: progress.progress,
                  color: _primaryColor,
                );
              },
              errorWidget: (
                context,
                url,
                error,
              ) {
                return const Icon(
                  Icons.error,
                  size: 80,
                );
              },
            ),
          ),
        ),
      );
    },
  );
}