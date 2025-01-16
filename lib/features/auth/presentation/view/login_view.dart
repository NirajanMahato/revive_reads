import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/app/constants/color_constants.dart';
import 'package:revive_reads/core/common/widgets/custom_elevated_button.dart';
import 'package:revive_reads/core/common/widgets/custom_text_field.dart';
import 'package:revive_reads/features/auth/presentation/view/register_view.dart';
import 'package:revive_reads/features/auth/presentation/view_model/login/login_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _loginFormKey,
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
                                Navigator.of(context)
                                    .pushNamed("/forget-password");
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
                          onPressed: () async {
                            if (_loginFormKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                    LoginUserEvent(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
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
                            "Don't have an account?",
                            style: TextStyle(fontSize: 15.0, color: kGreyColor),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              context.read<LoginBloc>().add(
                                    NavigateRegisterScreenEvent(
                                      context: context,
                                      destination: const RegisterView(),
                                    ),
                                  );
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
