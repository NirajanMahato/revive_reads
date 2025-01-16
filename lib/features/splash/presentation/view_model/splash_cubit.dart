import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/onBoarding/presentation/view/onboarding_screen_view.dart';
import 'package:revive_reads/features/onBoarding/presentation/view_model/onboarding_cubit.dart';

class SplashCubit extends Cubit<void> {
  SplashCubit(this._onboardingCubit) : super(null);

  final OnboardingCubit _onboardingCubit;

  Future<void> init(BuildContext context) async {
    // Simulate a 2-second delay
    await Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        // Navigate to the Onboarding Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _onboardingCubit,
              child: const OnboardingScreen(),
            ),
          ),
        );
      }
    });
  }
}
