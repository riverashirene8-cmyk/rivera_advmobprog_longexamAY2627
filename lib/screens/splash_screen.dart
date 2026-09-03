import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 
import '../constants.dart';
 
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
      _navigateToLogin();
    });
  }
 
  Future<void> _navigateToLogin() async {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
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
            const CircularProgressIndicator(color: fbPrimary),
          ],
        ),
      ),
    );
  }
}
 