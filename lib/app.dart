import 'package:flutter/material.dart';
import 'package:revive_reads/view/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Poppins',
        ),
      home: const LoginScreen(),
    );
  }
}
