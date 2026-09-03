import 'dart:async';
import 'dart:convert';
 
import 'package:http/http.dart' as http;
 
import '../constants.dart';
import '../models/user.dart';
 
class UserService {
  Future<List<AppUser>> getUsers({
    int limit = 100,
    int skip = 0,
  }) async {
    final response = await http.get(
      Uri.parse('$host/users?limit=$limit&skip=$skip'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
 
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load users: ${response.statusCode}',
      );
    }
 
    final dynamic data = jsonDecode(response.body);
 
    if (data is Map<String, dynamic> && data['users'] is List) {
      return (data['users'] as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(AppUser.fromJson)
          .toList();
    }
 
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(AppUser.fromJson)
          .toList();
    }
 
    throw Exception('Invalid users response');
  }
 
  Future<AppUser?> getUserById(int userId) async {
    final response = await http.get(
      Uri.parse('$host/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
 
    if (response.statusCode == 404) {
      return null;
    }
 
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load user: ${response.statusCode}',
      );
    }
 
    final dynamic data = jsonDecode(response.body);
 
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid user response');
    }
 
    return AppUser.fromJson(data);
  }
}