import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivera_mobprog/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getIsLogin();
    super.initState();
  }

  void getIsLogin() {
    Timer(
      const Duration(seconds: 6),
      () => Navigator.popAndPushNamed(context, '/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        height: ScreenUtil().screenHeight,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_heart.png'),
            SizedBox(height: ScreenUtil().setHeight(120)),
            const FlickrLoader(
              size: 18,
              gap: 18,
              duration: Duration(milliseconds: 700),
            ),
          ],
        ),
      ),
    );
  }
}

class FlickrLoader extends StatefulWidget {
  final double size;
  final double gap;
  final Duration duration;

  const FlickrLoader({
    super.key,
    this.size = 18,
    this.gap = 18,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  State<FlickrLoader> createState() => _FlickrLoaderState();
}

class _FlickrLoaderState extends State<FlickrLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size + widget.gap,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final t = Curves.easeInOut.transform(_c.value);

          final leftX = 0.0 + (widget.gap * t);
          final rightX = widget.gap - (widget.gap * t);

          final leftScale = 0.85 + 0.30 * t;
          final rightScale = 1.15 - 0.30 * t;

          final leftOnTop = t > 0.5;

          Widget dot(Color color, double x, double scale) {
            return Positioned(
              left: x,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }

          final blue = dot(fbPrimary, leftX, leftScale);
          final pink = dot(fbSecondary, rightX, rightScale);

          return Stack(
            alignment: Alignment.centerLeft,
            children: leftOnTop ? [pink, blue] : [blue, pink],
          );
        },
      ),
    );
  }
}
