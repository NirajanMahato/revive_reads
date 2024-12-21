import 'package:flutter/material.dart';
import 'package:revive_reads/constants.dart';
import 'package:revive_reads/core/common/widgets/custom_elevated_button.dart';
import 'package:revive_reads/core/common/widgets/custom_text_field.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dummy credentials for login validation
  final String dummyEmail = "nirajan@gmail.com";
  final String dummyPassword = "pass123";

  // Function to navigate to the homepage after successful login
  void navigateToHomePage() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email == dummyEmail && password == dummyPassword) {
      // If the credentials match, navigate to the homepage
      Navigator.of(context).pushReplacementNamed("/home");
    } else {
      // Show an error if the credentials don't match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/login.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 250,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(178, 204, 209, 224),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    )),
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 33.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w900),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
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
                    CustomTextField(
                      controller: _emailController,
                      validator: ValidateLogin.emailValidate,
                      keyboardType: TextInputType.emailAddress,
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
                    CustomTextField(
                      controller: _passwordController,
                      validator: ValidateLogin.passwordValidate,
                      keyboardType: TextInputType.visiblePassword,
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
                      onPressed: navigateToHomePage,
                      width: double.infinity,
                      textColor: Colors.white,
                      verticalPadding: 18.0,
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
          ],
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
