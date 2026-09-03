import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 
import 'custom_font.dart';
 
class CustomButton extends StatelessWidget {
  final String buttonType;
  final String buttonName;
  final Color fontColor;
  final Color outlineColor;
  final VoidCallback? onPressed;
 
  const CustomButton({
    super.key,
    this.buttonType = 'elevated',
    required this.buttonName,
    this.fontColor = Colors.white,
    required this.onPressed,
    this.outlineColor = const Color(0xFF0D47A1),
  });
 
  @override
  Widget build(BuildContext context) {
    final type = buttonType.toLowerCase();
 
    if (type == 'outlined') {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 10.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          side: BorderSide(color: outlineColor),
        ),
        child: CustomFont(
          text: buttonName,
          fontSize: 12.sp,
          color: fontColor,
        ),
      );
    }
 
    if (type == 'text') {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 10.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: CustomFont(
          text: buttonName,
          fontSize: 12.sp,
          color: fontColor,
        ),
      );
    }
 
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 30.w,
          vertical: 10.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: CustomFont(
        text: buttonName,
        fontSize: 12.sp,
        color: Colors.white,
      ),
    );
  }
}