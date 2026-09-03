import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

 

import '../constants.dart';

import '../services/auth_service.dart';

import '../services/storage_service.dart';

import '../widgets/custom_dialogs.dart';

import '../widgets/custom_inkwell_button.dart';

import '../widgets/custom_textformfield.dart';

 

class LogInScreen extends StatefulWidget {

  const LogInScreen({super.key});

 

  @override

  State<LogInScreen> createState() =>

      _LogInScreenState();

}

 

class _LogInScreenState

    extends State<LogInScreen> {

  final TextEditingController

  usernameController =

      TextEditingController();

 

  final TextEditingController

  passwordController =

      TextEditingController();

 

  final AuthService _authService =

      AuthService();

 

  final GlobalKey<FormState> _formKey =

      GlobalKey<FormState>();

 

  bool _isPasswordHidden = true;

  bool _isLoading = false;

 

  Future<void> login() async {

    if (!_formKey.currentState!.validate()) {

      return;

    }

 

    setState(() {

      _isLoading = true;

    });

 

    try {

      final user =

          await _authService.login(

        username: usernameController.text,

        password: passwordController.text,

      );

 

      await StorageService.saveAuthUser(user);

 

      if (!mounted) return;

 

      Navigator.pushNamedAndRemoveUntil(

        context,

        '/home',

        (_) => false,

      );

    } catch (e) {

      if (!mounted) return;

 

      customDialog(

        context,

        title: 'Login Failed',

        content:

            'Invalid username or password.',

      );

    } finally {

      if (mounted) {

        setState(() {

          _isLoading = false;

        });

      }

    }

  }

 

  @override

  void dispose() {

    usernameController.dispose();

    passwordController.dispose();

    super.dispose();

  }

 

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:

                const EdgeInsets.symmetric(

              horizontal: 25,

            ),

            child: Form(

              key: _formKey,

              child: Column(

                children: [

                  SizedBox(height: 35.h),

 

                  Image.asset(

                    'assets/images/logo_heart.png',

                    height: 180.h,

                  ),

 

                  SizedBox(height: 35.h),

 

                  CustomTextFormField(

                    controller:

                        usernameController,

                    hintText:

                        'Username or Email',

                    fontSize: 15,

                    hintTextSize: 15,

                    fontColor: fbPrimary,

                    height: 10,

                    width: 10,

                    validator: (value) {

                      if (value == null ||

                          value.trim().isEmpty) {

                        return 'Enter username';

                      }

                      return null;

                    },

                    onSaved: null,

                  ),

 

                  const SizedBox(height: 12),

 

                  CustomTextFormField(

                    controller:

                        passwordController,

                    hintText: 'Password',

                    isObscure:

                        _isPasswordHidden,

                    fontSize: 15,

                    hintTextSize: 15,

                    fontColor: fbPrimary,

                    height: 10,

                    width: 10,

                    validator: (value) {

                      if (value == null ||

                          value.isEmpty) {

                        return 'Enter password';

                      }

                      return null;

                    },

                    onSaved: null,

                    suffixIcon: IconButton(

                      icon: Icon(

                        _isPasswordHidden

                            ? Icons.visibility_off

                            : Icons.visibility,

                      ),

                      onPressed: () {

                        setState(() {

                          _isPasswordHidden =

                              !_isPasswordHidden;

                        });

                      },

                    ),

                  ),

 

                  SizedBox(height: 35.h),

 

                  CustomInkWellButton(

                    onTap:

                        _isLoading ? null : login,

                    height: 45,

                    width: double.infinity,

                    buttonName: _isLoading

                        ? 'Logging in...'

                        : 'Login',

                    fontSize: 15,

                  ),

 

                  SizedBox(height: 25.h),

 

                  Row(

                    mainAxisAlignment:

                        MainAxisAlignment.center,

                    children: [

                      const Text(

                        'You do not have an account? ',

                      ),

                      GestureDetector(

                        onTap: () {

                          Navigator.pushNamed(

                            context,

                            '/register',

                          );

                        },

                        child: const Text(

                          'Register here',

                          style: TextStyle(

                            color: fbPrimary,

                            fontWeight:

                                FontWeight.bold,

                          ),

                        ),

                      ),

                    ],

                  ),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}

 


