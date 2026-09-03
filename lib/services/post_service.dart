import 'dart:async';
import 'dart:convert';
 
import 'package:http/http.dart' as http;
 
import '../constants.dart';
import '../models/post.dart';
 
class PostService {
  Future<List<PostItem>> getPosts({
    int limit = 30,
    int skip = 0,
  }) async {
    final response = await http.get(
      Uri.parse('$host/posts?limit=$limit&skip=$skip'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
 
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load posts: ${response.statusCode}',
      );
    }
 
    final dynamic data = jsonDecode(response.body);
 
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid posts response');
    }
 
    final List<dynamic> postsJson =
        data['posts'] is List ? data['posts'] as List<dynamic> : [];
 
    return postsJson
        .whereType<Map<String, dynamic>>()
        .map(PostItem.fromJson)
        .toList();
  }
 
  Future<List<PostItem>> getPostsByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('$host/posts/user/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
 
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load user posts: ${response.statusCode}',
      );
    }
 
    final dynamic data = jsonDecode(response.body);
 
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid user posts response');
    }
 
    final List<dynamic> postsJson =
        data['posts'] is List ? data['posts'] as List<dynamic> : [];
 
    return postsJson
        .whereType<Map<String, dynamic>>()
        .map(PostItem.fromJson)
        .toList();
  }
 
  Future<PostItem> createPost({
    required int userId,
    required String title,
    required String body,
    List<String>? tags,
    List<String>? images,
  }) async {
    final response = await http.post(
      Uri.parse('$host/posts/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title.trim().isEmpty ? 'New post' : title.trim(),
        'body': body.trim(),
        'userId': userId,
        'tags': tags ?? <String>[],
        'images': images ?? <String>[],
      }),
    );
 
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Failed to create post: ${response.statusCode}',
      );
    }
 
    final dynamic data = jsonDecode(response.body);
 
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid post response');
    }
 
    return PostItem.fromJson(data);
  }
 
  Future<PostItem> updatePost({
    required int postId,
    required String title,
    required String body,
  }) async {
    final response = await http.put(
      Uri.parse('$host/posts/$postId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title.trim().isEmpty
            ? 'Updated post'
            : title.trim(),
        'body': body.trim(),
      }),
    );
 
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Failed to update post: ${response.statusCode}',
      );
    }
 
    final dynamic data = jsonDecode(response.body);
 
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid post response');
    }
 
    return PostItem.fromJson(data);
  }
 
  Future<void> deletePost(int postId) async {
    final response = await http.delete(
      Uri.parse('$host/posts/$postId'),
    );
 
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete post: ${response.statusCode}',
      );
    }
  }
}