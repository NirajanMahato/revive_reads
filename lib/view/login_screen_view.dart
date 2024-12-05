import 'package:flutter/material.dart';
import 'package:revive_reads/constants.dart';
import 'package:revive_reads/common/widgets/custom_elevated_button.dart';
import 'package:revive_reads/common/widgets/custom_text_field.dart';

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo/Logo2.png',
                    height: 190,
                    width: 190,
                  ),
                  const SizedBox(height: 10),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: kBlueGreyColor,
                            fontWeight: FontWeight.w600),
                      )),
                  const SizedBox(height: 6),
                  const CustomTextField(
                    validator: ValidateLogin.emailValidate,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    hintText: 'Your Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: kBlueGreyColor,
                            fontWeight: FontWeight.w600),
                      )),
                  const SizedBox(height: 6),
                  const CustomTextField(
                    validator: ValidateLogin.passwordValidate,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: Icons.lock,
                    hintText: 'Your Password',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/forget-password");
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomElevatedButton(
                    text: "Login",
                    onPressed: () {},
                    width: double.infinity,
                    textColor: Colors.white,
                    verticalPadding: 21.0,
                    fontSize: 18.0,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 15.0, color: kGreyColor),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                          Navigator.of(context).pushNamed("/register");
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
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
  static String? emailValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  }

  static String? passwordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
