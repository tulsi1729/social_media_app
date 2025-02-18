import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
}

String formatDateTimeString(DateTime date) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(date);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()} months ago';
  } else {
    return '${(difference.inDays / 365).floor()} years ago';
  }
}
