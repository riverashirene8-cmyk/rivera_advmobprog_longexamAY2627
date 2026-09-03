import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
class CustomTextFormField extends StatelessWidget {
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController controller;
 
  final bool isObscure;
  final double fontSize;
  final Color? fontColor;
 
  final double height;
  final double width;
 
  final double hintTextSize;
  final String hintText;
 
  final Color fillColor;
  final TextInputType keyboardType;
  final int maxLength;
 
  final Widget? suffixIcon;
  final Widget? prefixIcon;
 
  const CustomTextFormField({
    super.key,
    required this.validator,
    required this.onSaved,
    required this.controller,
    this.isObscure = false,
    this.fontSize = 14,
    this.fontColor = Colors.black,
    this.hintTextSize = 12,
    this.hintText = '',
    this.fillColor = Colors.black12,
    this.height = 12,
    this.width = 12,
    this.keyboardType = TextInputType.text,
    this.maxLength = 200,
    this.suffixIcon,
    this.prefixIcon,
  });
 
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1877F2);
 
    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      obscureText: isObscure,
      keyboardType: keyboardType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.fromLTRB(
          width,
          height,
          width,
          height,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black45,
          fontSize: hintTextSize,
        ),
      ),
    );
  }
}