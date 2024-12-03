import 'package:flutter/material.dart';
import 'package:revive_reads/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo/Logo2.png',
                    height: 170,
                    width: 170,
                  ),
                  const SizedBox(height: 10),
                  const CustomTextField(
                    validator: ValidateLogin.emailValidate,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    hintText: 'Your Email',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class ValidateLogin {
  static String? emailValidate(String? value){
    if (value == null || value.isEmpty){
      return 'Email is required';
    }
    return null;
  }

  static String? passwordValidate(String? value){
    if (value == null || value.isEmpty){
      return 'Password is required';
    }
    return null;
  }
}
