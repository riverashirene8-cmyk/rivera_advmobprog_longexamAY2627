import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class StorageService {
  static const String _keyLoggedIn = 'is_logged_in';
  static const String _keyUser = 'auth_user';
  static const String _keyDarkMode = 'dark_mode';

  // ENHANCEMENT 1:
  // Save the authenticated user's login status and user data
  // using SharedPreferences.
  static Future<void> saveAuthUser(
    AppUser user,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _keyLoggedIn,
      true,
    );

    await prefs.setString(
      _keyUser,
      jsonEncode(user.toJson()),
    );
  }

  // ENHANCEMENT 1:
  // Retrieve the saved authenticated user.
  static Future<AppUser?> getAuthUser() async {
    final prefs =
        await SharedPreferences.getInstance();

    final isLoggedIn =
        prefs.getBool(_keyLoggedIn) ?? false;

    if (!isLoggedIn) {
      return null;
    }

    final raw =
        prefs.getString(_keyUser);

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return AppUser.fromJson(
        decoded,
        token: decoded['token']?.toString(),
      );
    } catch (_) {
      return null;
    }
  }

  // ENHANCEMENT 1:
  // Check whether a valid authenticated user exists.
  static Future<bool> isLoggedIn() async {
    final user = await getAuthUser();

    return user != null;
  }

  // ENHANCEMENT 2:
  // Clear the saved authentication information when
  // the user signs out of the application.
  static Future<void> clearAuthUser() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _keyLoggedIn,
      false,
    );

    await prefs.remove(_keyUser);
  }

  // ENHANCEMENT 2:
  // Save the user's selected dark mode preference.
  static Future<void> saveDarkMode(
    bool value,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _keyDarkMode,
      value,
    );
  }

  // ENHANCEMENT 2:
  // Retrieve the saved dark mode preference.
  static Future<bool> getDarkMode() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_keyDarkMode) ?? false;
  }
}