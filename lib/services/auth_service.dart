import 'dart:async';
import 'dart:convert';
 
import 'package:http/http.dart' as http;
 
import '../models/user.dart';
 
class AuthService {
  Future<AppUser> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username.trim(),
        'password': password.trim(),
        'expiresInMins': 60,
      }),
    );
 
    if (response.statusCode != 200) {
      throw Exception('Invalid username or password');
    }
 
    final data = jsonDecode(response.body);
 
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid server response');
    }
 
    final token =
        (data['accessToken'] ?? data['token'] ?? '').toString();
 
    if (token.isEmpty) {
      throw Exception('Authentication token missing');
    }
 
    return AppUser.fromJson(
      data,
      token: token,
    );
  }
}