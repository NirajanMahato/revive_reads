import 'package:flutter/material.dart';
import 'package:revive_reads/view/forgot_password_view.dart';
import 'package:revive_reads/view/bottom_navigation_view.dart';
import 'package:revive_reads/view/login_screen_view.dart';
import 'package:revive_reads/view/onboarding_screen_view.dart';
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
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenView(),
         '/onboarding1': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreenView(),
        '/register': (context) => const RegisterScreenView(),
        '/forget-password': (context) => const ForgotPasswordView(),
        '/home': (context) => const BottomNavigationView(),
      },
    );
  }
}
