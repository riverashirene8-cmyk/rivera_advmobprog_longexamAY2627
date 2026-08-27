import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivera_mobprog/constants.dart';
import 'package:rivera_mobprog/widgets/custom_textformfield.dart';
import '../widgets/custom_inkwell_button.dart';
import 'package:rivera_mobprog/widgets/custom_dialogs.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(String? registeredName) {
    if (usernameController.text == 'user' &&
        passwordController.text == 'user') {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: registeredName ?? usernameController.text,
      );
    } else {
      customDialog(
        context,
        title: 'Error',
        content: 'Username and password does not matched',
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    /// ✅ NAME FROM REGISTER
    final String? registeredName =
        ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 40, color: fbPrimary),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_heart.png',
                        height: 200,
                      ),
                      SizedBox(height: 30),

                      CustomTextFormField(
                        controller: usernameController,
                        hintText: 'Username or Email',
                        fontSize: 15,
                        hintTextSize: 15,
                        fontColor: fbPrimary,
                        height: 10,
                        width: 10,
                        validator: (v) => v!.isEmpty ? 'Enter username' : null,
                        onSaved: null,
                      ),

                      SizedBox(height: 10),

                      CustomTextFormField(
                        controller: passwordController,
                        hintText: 'Password',
                        isObscure: _isPasswordHidden,
                        fontSize: 15,
                        hintTextSize: 15,
                        fontColor: fbPrimary,
                        height: 10,
                        width: 10,
                        validator: (v) => v!.isEmpty ? 'Enter password' : null,
                        onSaved: null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _isPasswordHidden = !_isPasswordHidden,
                          ),
                        ),
                      ),

                      SizedBox(height: 40),

                      CustomInkWellButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            login(registeredName);
                          }
                        },
                        height: 40,
                        width: double.infinity,
                        buttonName: 'Login',
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 40,
                  color: fbPrimary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You do not have an account? ',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.popAndPushNamed(context, '/register'),
                        child: const Text(
                          'Register here',
                          style: TextStyle(
                            color: fbSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
