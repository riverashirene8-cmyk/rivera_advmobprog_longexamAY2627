import 'package:flutter/material.dart';
 
import 'custom_font.dart';
 
class CustomInkWellButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double height;
  final double width;
  final double fontSize;
  final String buttonName;
  final Icon? icon;
  final FontWeight fontWeight;
  final Color bgColor;
  final Color fontColor;
 
  const CustomInkWellButton({
    super.key,
    required this.onTap,
    required this.height,
    required this.width,
    this.buttonName = '',
    this.bgColor = const Color(0xFF1877F2),
    this.fontColor = Colors.white,
    this.fontSize = 14,
    this.icon,
    this.fontWeight = FontWeight.normal,
  });
 
  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.white24,
        child: SizedBox(
          height: height,
          width: width,
          child: Center(
            child: buttonName.isEmpty
                ? icon
                : CustomFont(
                    text: buttonName,
                    fontSize: fontSize,
                    color: fontColor,
                    fontWeight: fontWeight,
                  ),
          ),
        ),
      ),
    );
  }
}