import 'package:flutter/material.dart';
import 'package:revive_reads/view/forgot_password_view.dart';
import 'package:revive_reads/view/home_screen_view.dart';
import 'package:revive_reads/view/login_screen_view.dart';
import 'package:revive_reads/view/onboarding_screen_1.dart';
import 'package:revive_reads/view/onboarding_screen_2.dart';
import 'package:revive_reads/view/register_screen_view.dart';
import 'package:revive_reads/view/splash_screen_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.purple,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenView(),
         '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/login': (context) => const LoginScreenView(),
        '/register': (context) => const RegisterScreenView(),
        '/forget-password': (context) => const ForgotPasswordView(),
        '/home': (context) => const HomeScreenView(),
      },
    );
  }
}
