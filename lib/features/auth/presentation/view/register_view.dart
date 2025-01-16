import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/app/constants/color_constants.dart';
import 'package:revive_reads/core/common/widgets/custom_elevated_button.dart';
import 'package:revive_reads/core/common/widgets/custom_text_field.dart';
import 'package:revive_reads/features/auth/presentation/view_model/signup/register_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerViewFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerViewFormKey,
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
              height: 240,
              child: Image.asset(
                'assets/images/register.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 230,
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
                        'Register',
                        style: TextStyle(
                            fontSize: 33.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w900),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Full name',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: kBlueGreyColor,
                            fontWeight: FontWeight.w600),
                      )),
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: _nameController,
                    validator: ValidateLogin.fullNameValidate,
                    keyboardType: TextInputType.name,
                    hintText: 'Your Full Name',
                  ),
                  const SizedBox(
                    height: 20,
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
                    height: 50,
                  ),
                  CustomElevatedButton(
                    text: "Sign Up",
                    onPressed: () {
                      if (_registerViewFormKey.currentState!.validate()) {
                        context.read<RegisterBloc>().add(
                              RegisterUserEvent(
                                context: context,
                                fullName: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill all the feilds')),
                        );
                      }
                    },
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
                      "Already have an account?",
                      style: TextStyle(fontSize: 15.0, color: kGreyColor),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        // context.read<RegisterBloc>().add(
                        //       NavigateLoginScreenEvent(
                        //         context: context,
                        //         destination: const LoginView(),
                        //       ),
                        //     );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ))),
    );
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