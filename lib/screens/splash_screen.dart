import 'package:flutter/material.dart';

import '../constants.dart';
import '../services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  // ENHANCEMENT 1:
  // Check SharedPreferences to determine whether the user is logged in.
  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await StorageService.isLoggedIn();

    if (!mounted) return;

    // ENHANCEMENT 1:
    // Navigate to Home when the user is already logged in.
    // Otherwise, navigate to the Login screen.
    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fbPrimary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.favorite,
                size: 50,
                color: fbPrimary,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: fbPrimary,
            ),
          ],
        ),
      ),
    );
  }
}