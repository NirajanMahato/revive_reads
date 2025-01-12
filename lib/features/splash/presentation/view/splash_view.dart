import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/splash/presentation/view_model/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Initialize the splash cubit and navigate to the onboarding screen
    context.read<SplashCubit>().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            SizedBox(
              height: 110,
              child: Image.asset('assets/logo/Logo1.png'),
            ),
            const SizedBox(height: 10),
            // App Title
            const Text(
              "Revive Reads",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Loading Indicator
            const CircularProgressIndicator(), // Added progress indicator
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
