import 'package:flutter/material.dart';
 
import '../constants.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';
 
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
 
  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}
 
class _RegisterScreenState
    extends State<RegisterScreen> {
  final firstnameController =
      TextEditingController();
 
  final lastnameController =
      TextEditingController();
 
  final mobilenumberController =
      TextEditingController();
 
  final passwordController =
      TextEditingController();
 
  final confirmpasswordController =
      TextEditingController();
 
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
 
  void register() {
    if (firstnameController.text
            .trim()
            .isEmpty ||
        lastnameController.text
            .trim()
            .isEmpty ||
        mobilenumberController.text
            .trim()
            .isEmpty ||
        passwordController.text.isEmpty ||
        confirmpasswordController
            .text
            .isEmpty) {
      customDialog(
        context,
        title: 'Error',
        content:
            'All fields are required.',
      );
      return;
    }
 
    if (mobilenumberController
            .text
            .trim()
            .length !=
        11) {
      customDialog(
        context,
        title: 'Error',
        content:
            'Mobile number must be 11 digits.',
      );
      return;
    }
 
    final password =
        passwordController.text;
 
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
    );
 
    if (!passwordRegex.hasMatch(
      password,
    )) {
      customDialog(
        context,
        title: 'Error',
        content:
            'Password must have at least 8 characters, uppercase, lowercase, number, and special character.',
      );
      return;
    }
 
    if (password !=
        confirmpasswordController
            .text) {
      customDialog(
        context,
        title: 'Error',
        content:
            'Passwords do not match.',
      );
      return;
    }
 
    customDialog(
      context,
      title: 'Success',
      content:
          'Registration successful!',
    );
  }
 
  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    mobilenumberController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fbPrimary,
        foregroundColor: Colors.white,
        title:
            const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 20),
 
            const Text(
              'Register Here',
              style: TextStyle(
                fontSize: 32,
                fontWeight:
                    FontWeight.bold,
                color: fbDarkPrimary,
              ),
            ),
 
            const SizedBox(height: 25),
 
            CustomTextFormField(
              controller:
                  firstnameController,
              hintText: 'First name',
              fontSize: 15,
              hintTextSize: 15,
              height: 10,
              width: 10,
              validator: (_) => null,
              onSaved: null,
              fontColor: Colors.black,
            ),
 
            const SizedBox(height: 10),
 
            CustomTextFormField(
              controller:
                  lastnameController,
              hintText: 'Last name',
              fontSize: 15,
              hintTextSize: 15,
              height: 10,
              width: 10,
              validator: (_) => null,
              onSaved: null,
              fontColor: Colors.black,
            ),
 
            const SizedBox(height: 10),
 
            CustomTextFormField(
              controller:
                  mobilenumberController,
              hintText: 'Mobile Number',
              keyboardType:
                  TextInputType.number,
              maxLength: 11,
              fontSize: 15,
              hintTextSize: 15,
              height: 10,
              width: 10,
              validator: (_) => null,
              onSaved: null,
              fontColor: Colors.black,
            ),
 
            const SizedBox(height: 10),
 
            CustomTextFormField(
              controller:
                  passwordController,
              hintText: 'Password',
              isObscure:
                  _isPasswordHidden,
              fontColor: Colors.black,
              fontSize: 15,
              hintTextSize: 15,
              height: 10,
              width: 10,
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
                    _isPasswordHidden =
                        !_isPasswordHidden;
                  });
                },
              ),
            ),
 
            const SizedBox(height: 8),
 
            const Text(
              'Password must be at least 8 characters with uppercase, lowercase, number and special character.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
 
            const SizedBox(height: 10),
 
            CustomTextFormField(
              controller:
                  confirmpasswordController,
              hintText:
                  'Confirm Password',
              isObscure:
                  _isConfirmPasswordHidden,
              fontColor: Colors.black,
              fontSize: 15,
              hintTextSize: 15,
              height: 10,
              width: 10,
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
 
            const SizedBox(height: 25),
 
            CustomInkWellButton(
              onTap: register,
              height: 45,
              width: double.infinity,
              fontSize: 15,
              fontWeight:
                  FontWeight.bold,
              buttonName: 'Submit',
            ),
 
            const SizedBox(height: 15),
 
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Text(
                  'You have an account? ',
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    'Login here',
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
    );
  }
    }