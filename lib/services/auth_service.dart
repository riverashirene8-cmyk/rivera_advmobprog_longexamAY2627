import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthService {
  // ENHANCEMENT 1:
  // Authenticate the user using the DummyJSON authentication API.
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

    // ENHANCEMENT 1:
    // Get the authentication token returned by the DummyJSON API.
    final token =
        (data['accessToken'] ?? data['token'] ?? '').toString();

    if (token.isEmpty) {
      throw Exception('Authentication token missing');
    }

    // ENHANCEMENT 1:
    // Convert the authenticated API response into the application's user model.
    return AppUser.fromJson(
      data,
      token: token,
    );
  }
}