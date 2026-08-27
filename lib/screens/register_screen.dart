import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivera_mobprog/constants.dart';
import 'package:rivera_mobprog/widgets/custom_font.dart';
import 'package:rivera_mobprog/widgets/custom_inkwell_button.dart';
import 'package:rivera_mobprog/widgets/custom_textformfield.dart';
import '../widgets/custom_dialogs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  void register() {
    if (firstnameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        mobilenumberController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmpasswordController.text.isEmpty) {
      customDialog(
        context,
        title: 'Error',
        content: 'All fields are required to continue.',
      );
      return;
    }

    if (mobilenumberController.text.length != 11) {
      customDialog(
        context,
        title: 'Error',
        content: 'The mobile number must be 11 digits.',
      );
      return;
    }

    final password = passwordController.text;
    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

    if (!passwordRegex.hasMatch(password)) {
      customDialog(
        context,
        title: 'Error',
        content:
            'Password should be at least 8 characters, include uppercase, lowercase, number, and special character.',
      );
      return;
    }

    if (password != confirmpasswordController.text) {
      customDialog(
        context,
        title: 'Error',
        content: 'Passwords do not match.',
      );
      return;
    }

    customDialog(
      context,
      title: 'Success',
      content: 'Registration successful!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(40),
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(10),
          ),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(25)),

              CustomFont(
                text: 'Register Here',
                fontSize: ScreenUtil().setSp(40),
                fontWeight: FontWeight.bold,
                color: fbDarkPrimary,
              ),

              SizedBox(height: ScreenUtil().setHeight(25)),

              /// FIRST NAME
              CustomTextFormField(
                controller: firstnameController,
                hintText: 'First name',
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                validator: (_) => null,
                onSaved: null,
                fontColor: Colors.black,
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              /// LAST NAME
              CustomTextFormField(
                controller: lastnameController,
                hintText: 'Last name',
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                validator: (_) => null,
                onSaved: null,
                fontColor: Colors.black,
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              /// MOBILE NUMBER
              CustomTextFormField(
                controller: mobilenumberController,
                hintText: 'Mobile Number',
                keyboardType: TextInputType.number,
                maxLength: 11,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                validator: (_) => null,
                onSaved: null,
                fontColor: Colors.black,
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              /// PASSWORD
              CustomTextFormField(
                controller: passwordController,
                hintText: 'Password',
                isObscure: _isPasswordHidden,
                fontColor: Colors.black,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                validator: (_) => null,
                onSaved: null,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(8)),

              Text(
                'Password should be 8 characters, include uppercase, lowercase, number, and special character.',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: ScreenUtil().setSp(10),
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(10)),

              /// CONFIRM PASSWORD
              CustomTextFormField(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
                isObscure: _isConfirmPasswordHidden,
                fontColor: Colors.black,
                fontSize: ScreenUtil().setSp(15),
                hintTextSize: ScreenUtil().setSp(15),
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                validator: (_) => null,
                onSaved: null,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordHidden =
                          !_isConfirmPasswordHidden;
                    });
                  },
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(20)),

              CustomInkWellButton(
                onTap: register,
                height: ScreenUtil().setHeight(45),
                width: ScreenUtil().screenWidth,
                fontSize: ScreenUtil().setSp(15),
                fontWeight: FontWeight.bold,
                buttonName: 'Submit',
              ),

              SizedBox(height: ScreenUtil().setHeight(15)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have an account? ',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.popAndPushNamed(context, '/login'),
                    child: Text(
                      'Login here',
                      style: TextStyle(
                        color: fbDarkPrimary,
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
