import 'package:flutter/material.dart';
import 'package:revive_reads/view/login_screen_view.dart';
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
        '/loign': (context) => const LoginScreenView(),
      },
    );
  }
}
