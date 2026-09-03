import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

class CommentService {

  // ENHANCEMENT 3:
  // Fetch all comments based on the selected post.
  Future<List<CommentItem>> getCommentsForPost(int postId) async {
    final response = await http.get(
      Uri.parse('$host/comments/post/$postId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load comments');
    }

    final dynamic data = jsonDecode(response.body);

    List<dynamic> commentsJson = [];

    if (data is Map<String, dynamic> && data['comments'] is List) {
      commentsJson = data['comments'] as List<dynamic>;
    } else if (data is List) {
      commentsJson = data;
    }

    return commentsJson
        .whereType<Map<String, dynamic>>()
        .map(CommentItem.fromJson)
        .toList();
  }

  // ENHANCEMENT 3:
  // Provide comments associated with a specific post.
  Future<List<CommentItem>> getCommentsByPost(int postId) async {
    return getCommentsForPost(postId);
  }

  // ENHANCEMENT 3:
  // Allow the user to add a comment to the selected post.
  Future<CommentItem> addComment({
    required int postId,
    required int userId,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('$host/comments/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'body': body.trim(),
        'postId': postId,
        'userId': userId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }

    final dynamic data = jsonDecode(response.body);

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid comment response');
    }

    return CommentItem.fromJson(data);
  }

  Future<CommentItem> updateComment({
    required int commentId,
    required String body,
  }) async {
    final response = await http.put(
      Uri.parse('$host/comments/$commentId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'body': body.trim(),
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update comment');
    }

    final dynamic data = jsonDecode(response.body);

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid comment response');
    }

    return CommentItem.fromJson(data);
  }

  Future<void> deleteComment(int commentId) async {
    final response = await http.delete(
      Uri.parse('$host/comments/$commentId'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete comment');
    }
  }

  // ENHANCEMENT 3:
  // Support the like action for a comment.
  Future<void> likeComment({
    required int commentId,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('$host/comments/$commentId/like'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to like comment');
    }
  }

  Future<CommentItem> addReply({
    required int commentId,
    required int userId,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('$host/comments/$commentId/reply'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'body': body.trim(),
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add reply');
    }

    final dynamic data = jsonDecode(response.body);

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid reply response');
    }

    return CommentItem.fromJson(data);
  }
}