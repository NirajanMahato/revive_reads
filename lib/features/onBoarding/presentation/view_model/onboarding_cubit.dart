import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/auth/presentation/view/login_view.dart';

class OnboardingCubit extends Cubit<void> {
  OnboardingCubit() : super(null);

  void navigateToLogin(BuildContext context) {
    if (context.mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ));
    }
  }
}