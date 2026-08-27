import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivera_mobprog/screens/login_screen.dart';
import 'package:rivera_mobprog/screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          title: 'Facebook Replication',
          initialRoute: '/splash',
          routes: {
            '/login': (context) => const LogInScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/splash': (context) => const SplashScreen(),
          },
        );
      },
    );
  }
}
