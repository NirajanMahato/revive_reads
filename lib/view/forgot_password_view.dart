import 'package:flutter/material.dart';
import 'package:revive_reads/common/widgets/custom_elevated_button.dart';
import 'package:revive_reads/common/widgets/custom_text_field.dart';
import 'package:revive_reads/constants.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController _passwordController = TextEditingController();

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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 13.0, right: 19.0),
                      child: Text(
                        "Seems you lost your key",
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 21, 21, 21),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 38.0),
                    child: Text(
                      "Please input your email to get code verification to reset your password.",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: kBlueGreyColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
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
                    controller: _passwordController,
                    validator: ValidateLogin.emailValidate,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Your Email',
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomElevatedButton(
                    text: "Send Code",
                    onPressed: () {},
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
                      "Have a problem?",
                      style: TextStyle(fontSize: 15.0, color: kGreyColor),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/login");
                      },
                      child: const Text(
                        "Contact us",
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
  static String? fullNameValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 3) {
      return 'Full name must be at least 3 characters long';
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

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
